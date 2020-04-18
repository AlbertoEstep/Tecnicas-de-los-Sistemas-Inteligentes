// TSI - Práctica 1
// CARLOS SANTIAGO SÁNCHEZ MUÑOZ
// ALBERTO ESTEPA FERNÁNDEZ

package practica_busqueda;

import core.game.StateObservation;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.Vector2d;
import tools.pathfinder.Node;

import java.util.ArrayList;
import java.util.PriorityQueue;

public class Agent extends BaseAgent{
    private ArrayList<Node> path;                           // Lista de nodos del camino
    PlayerObservation playerObs;                            // Jugador
    private Vector2d ultimaPos;                             // Última posición del jugador

    //Listas de gemas
    private ArrayList<Observation> gemsList;                // Todas
    private ArrayList<Observation> gemsListReachable;       // Alcanzables
    private ArrayList<Observation> gemsListBoulderAbove;    // Alcanzables + roca encima
    private ArrayList<Observation> gemsListNotBoulderAbove; // Alcanzables - roca encima

    private Observation nextGoal = null;                    // Próximo objetivo (gema o puerta)
    private int gotGems;                                    // Gemas ya alcanzadas

    private static int ancho;                                              // Anchura del grid
    private static int alto;                                               // Altura del grid
    private ArrayList<Observation>[][] grid = null;         // Grid del juego
    ArrayList<ObservationType> obstacleTypes;               // Obstaculos posibles
    private int quieto;                                     // Entero con el número de veces sin moverse

    // Constructor
    public Agent(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
        super(stateObs,elapsedTimer);

        obstacleTypes = new ArrayList();
        obstacleTypes.add(ObservationType.WALL);
        obstacleTypes.add(ObservationType.BOULDER);
        obstacleTypes.add(ObservationType.BAT);
        obstacleTypes.add(ObservationType.SCORPION);

        ancho = stateObs.getWorldDimension().width / stateObs.getBlockSize();
        alto = stateObs.getWorldDimension().height / stateObs.getBlockSize();

        this.path = new ArrayList<>();
        grid = getObservationGrid(stateObs);
        playerObs = getPlayer(stateObs);
        ultimaPos = new Vector2d(getPlayer(stateObs).getX(), getPlayer(stateObs).getY());

        // Inicializamos las listas de gemas
        gemsList = new ArrayList<>();
        gemsListReachable = new ArrayList<>();
        gemsListBoulderAbove = new ArrayList<>();
        gemsListNotBoulderAbove = new ArrayList<>();
        calculateGems(stateObs);

        gotGems = 0;
        quieto = 0;
    }

    /////////////////////////
    //  MÉTODO PRINCIPAL   //
    /////////////////////////

    // Método más importante. Gestiona el proceso. Busca la mejor gema y el mejor camino a ella.
    // Devuelve la acción a llevar a cabo.
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer){
        //try { Thread.sleep(1);
        //} catch (InterruptedException e) { e.printStackTrace(); }

        // Actualizamos el jugador y el grid
        playerObs = getPlayer(stateObs);
        grid = getObservationGrid(stateObs);
        Vector2d player = new Vector2d(playerObs.getX(), playerObs.getY());

        // Vemos si el jugador ha cambiado la posición
        if((player.x != ultimaPos.x) || (player.y != ultimaPos.y)){
            quieto = 0;
            if(!path.isEmpty()) path.remove(0); //actualizamos plan
        }
        else ++quieto;

        // Actualizamos el numero de gemas que lleva encima
        if(getNumGems(stateObs) > gotGems){
            quieto = 0;
            gotGems = getNumGems(stateObs);
            path.clear();

            System.out.println("¡¡GEMA NÚMERO " + gotGems + " CONSEGUIDA!!");
        }

        // Si no hay un plan de ruta calculado
        if( path.isEmpty() || quieto>=4 || monsterClosed(playerObs.getX(),playerObs.getY())
                || boulderAbovePlayer(playerObs.getX(),playerObs.getY()) ){
            // Si ya tiene todas las gemas calcula ruta al portal más cercano
            if(gotGems >= NUM_GEMS_FOR_EXIT){
                practica_busqueda.Observation portalObs = getExit(stateObs);        // portal más cercano.
                Vector2d portal = new Vector2d(portalObs.getX(), portalObs.getY()); // guardamos como posición 2D.

                //Calculamos un camino desde la posición del avatar a la posición del portal
                Node por = new Node(portal);
                Node pla = new Node(player);
                path = findPathMap(pla, por);
                System.out.println("Calculando ruta desde player (" + player.x + "," + player.y +
                        ") hacia el portal (" + portal.x + "," + portal.y + ")");
            }

            // En otro caso se calcula la ruta a la gema más cercana
            else{
                nextGoal = bestGem(stateObs);

                if(nextGoal!=null) {
                    Vector2d gema = new Vector2d(nextGoal.getX(), nextGoal.getY());

                    //Calculamos un camino desde la posición del avatar a la posición de la gema
                    Node gem = new Node(gema);
                    Node pla = new Node(player);
                    path = findPathMap(pla, gem);     // path es no null porque la gema es alcanzable
                    System.out.println("Calculando ruta desde player (" + player.x + "," + player.y +
                            ") hacia la gema (" + gema.x + "," + gema.y + ")");
                }
                else
                    path = null;
            }
        }

        if(path==null) {
            System.out.println("PATH NULL");
            Node pos = null;
            Node pla = new Node(player);

            while(path==null){
                pos = calculatePos();
                path = findPathMap(pla, pos);
            }
        }

        if(!path.isEmpty()){
            Types.ACTIONS siguienteAccion = null;
            Node siguientePos = path.get(0);

            //Se determina el siguiente movimiento a partir de la posición del avatar
            if(siguientePos.position.x != player.x){
                if (siguientePos.position.x > player.x)
                    siguienteAccion = Types.ACTIONS.ACTION_RIGHT;
                else
                    siguienteAccion = Types.ACTIONS.ACTION_LEFT;
            }
            else if(siguientePos.position.y != player.y){
                if(siguientePos.position.y > player.y)
                    siguienteAccion = Types.ACTIONS.ACTION_DOWN;
                else
                    siguienteAccion = Types.ACTIONS.ACTION_UP;
            }

            ultimaPos = player;     //Se actualiza la ultima posición del avatar

            return siguienteAccion; //Se devuelve la acción deseada
        }
        return Types.ACTIONS.ACTION_NIL;
    }

    // Devuelve si en una posición hay un determinado ObservationType.
    private boolean isType(int x, int y, ObservationType type){
        for(Observation obs: grid[x][y]){
            if(obs.getType()==type)
                return true;
        }
        return false;
    }

    // Cuando no hay absolutamente nada que hacer se llama a este método para hacer algunos movimientos y que no de NULL.
    private Node calculatePos(){
        Node n = null;
        int x = playerObs.getX();
        int y = playerObs.getY();

        if(!isObstacle(x-1,y) && !isType(x-1, y-1, ObservationType.BOULDER)) n = new Node(new Vector2d(x-1,y));
        else if(!isObstacle(x+1,y) && !isType(x+1, y-1, ObservationType.BOULDER)) n = new Node(new Vector2d(x+1,y));
        else if(!isObstacle(x,y+1) && !isType(x, y, ObservationType.BOULDER)) n = new Node(new Vector2d(x,y+1));
        else if(y>2) if(!isObstacle(x,y-1) && !isType(x,y-2, ObservationType.BOULDER)) n = new Node(new Vector2d(x,y-1));
        else n = new Node(new Vector2d(x,y));

        return n;
    }

    // Nos devuelve si hay un monstruo cerca. Tiene en cuenta las cuatro casillas en horizontal más cercanas al muñeco
    // las cuatro verticales más cercanas y las de las esquinas. Dibujo:
    //    o
    //   ooo
    //  ooPoo
    //   ooo
    //    o
    private boolean monsterClosed(int x, int y){
        // Comprobamos línea horizontal
        if(x-2 > 0)
            if(isMonster(x-2,y)) return true;
        if(isMonster(x-1,y)) return true;
        if(isMonster(x+1,y)) return true;
        if(x+2 < ancho)
            if(isMonster(x+2,y)) return true;

        // Comprobamos línea vertical
        if(y-2 > 0)
            if(isMonster(x,y-2)) return true;
        if(isMonster(x,y-1)) return true;
        if(isMonster(x,y+1)) return true;
        if(y+2 < alto)
            if(isMonster(x,y+2)) return true;

        // Comprobamos las diagonales distancia 1
        if(isMonster(x-1,y-1)) return true;
        if(isMonster(x+1,y-1)) return true;
        if(isMonster(x-1,y+1)) return true;
        if(isMonster(x+1,y+1)) return true;

        return false;
    }

    // Nos dice si hay una roca encima dos posiciones encima cuando en una encima.
    // la casilla está vacía. Se usa para el player.
    private boolean boulderAbovePlayer(int x, int y){
        if(isType(x,y-1, ObservationType.EMPTY) && y-2>0){
            return isType(x,y-2,ObservationType.BOULDER);
        }

        return false;
    }

    ///////////////////////////////////////////
    //  CALCULANDO LA GEMA MÁS PROMETEDORA   //
    ///////////////////////////////////////////

    // Devuelve cuál es la gema más cercana de las que se le pasan como parámetro.
    private Observation nearestGem(ArrayList<Observation> list){
        if (list.size() > 0) {
            double xDiff = Math.abs(playerObs.getX() - list.get(0).getX());
            double yDiff = Math.abs(playerObs.getY() - list.get(0).getY());
            double minimo = xDiff + yDiff;
            int pos = 0;
            for (int i = 1; i < list.size(); ++i) {
                xDiff = Math.abs(playerObs.getX() - list.get(i).getX());
                yDiff = Math.abs(playerObs.getY() - list.get(i).getY());

                if (minimo > (xDiff + yDiff)) {
                    pos = i;
                    minimo = xDiff + yDiff;
                }
            }
            return list.get(pos);
        }
        else
            return null;
    }

    private Node liberateGemsFromBelow(){
        int x, y;

        for(Observation obs:gemsList){  // Son todas inalcanzables
            x = obs.getX();
            y = obs.getY();
            Node start = new Node(new Vector2d(playerObs.getX(),playerObs.getY()));

            while(y<alto){
                if(isType(x,y,ObservationType.BOULDER)) {
                    Node goal = new Node(new Vector2d(x,y+1));
                    if(findPathMap(start, goal)!=null)
                        return goal;
                }

                ++y;
            }
        }

        return null;
    }

    // Libera gemas desde la derecha
    private Node liberateGemsOnTheRight(){
        int x, y;

        for(Observation obs:gemsList){  // Son todas inalcanzables
            x = obs.getX();
            y = obs.getY();
            Node start = new Node(new Vector2d(playerObs.getX(),playerObs.getY()));

            while(x<ancho-1 && !isType(x,y,ObservationType.BOULDER)){
                ++x;
            }
            if (isType(x,y,ObservationType.BOULDER)){
                while(y<alto){
                    if(isType(x,y,ObservationType.BOULDER)) {
                        Node goal = new Node(new Vector2d(x,y+1));
                        if(findPathMap(start, goal)!=null)
                            return goal;
                    }

                    ++y;
                }
            }
        }

        return null;
    }

    // Libera gemas desde la izquierda
    private Node liberateGemsOnTheLeft(){
        int x, y;

        for(Observation obs:gemsList){  // Son todas inalcanzables
            x = obs.getX();
            y = obs.getY();
            Node start = new Node(new Vector2d(playerObs.getX(),playerObs.getY()));

            while(x>0 && !isType(x,y,ObservationType.BOULDER)){
                --x;
            }
            if (isType(x,y,ObservationType.BOULDER)){
                while(y<alto){
                    if(isType(x,y,ObservationType.BOULDER)) {
                        Node goal = new Node(new Vector2d(x,y+1));
                        if(findPathMap(start, goal)!=null)
                            return goal;
                    }

                    ++y;
                }
            }
        }

        return null;
    }

    // Cuando no hay ninguna gema alcanzable intenta liberarla tirando rocas.
    private Node liberateGems(StateObservation stateObs){
        // Si ha entrado aquí es porque gemsListReachable.isEmpty() es true
        Node goal = liberateGemsFromBelow();
        if(goal == null) goal = liberateGemsOnTheRight();
        if (goal == null) goal = liberateGemsOnTheLeft();
        if(goal == null) goal = liberateMonsters(stateObs);
        //puede ser que no podamos tirar más rocas y que la gema sea alcanzable
        // un monstruo puede ser el obstáculo

        return goal;
    }

    // Intenta cavar para liberar monstruos y que se choquen.
    private Node liberateMonsters(StateObservation stateObs){
        // Si ha entrado aquí es porque gemsList.isEmpty() es true
        // o hay una gema inalcanzable por un monstruo
        int x, y;
        Node start = new Node(new Vector2d(playerObs.getX(),playerObs.getY()));
        Node goal = null;
        ArrayList<Observation>[] enemiesList = getEnemiesList(stateObs);

        for(int i=0; i<enemiesList.length; ++i){
            for(int j=0; j<enemiesList[i].size(); ++j){
                x = enemiesList[i].get(j).getX();
                y = enemiesList[i].get(j).getY();

                goal = new Node(new Vector2d(x-1, y));
                if(findPathMap(start,goal)!=null){
                    obstacleTypes.add(ObservationType.GROUND);
                    if(findPathMap(start,goal)==null){
                        obstacleTypes.remove(ObservationType.GROUND);
                        return goal;
                    }
                    obstacleTypes.remove(ObservationType.GROUND);
                }

                goal = new Node(new Vector2d(x+1, y));
                if(findPathMap(start,goal)!=null){
                    obstacleTypes.add(ObservationType.GROUND);
                    if(findPathMap(start,goal)==null){
                        obstacleTypes.remove(ObservationType.GROUND);
                        return goal;
                    }
                    obstacleTypes.remove(ObservationType.GROUND);
                }

                goal = new Node(new Vector2d(x, y-1));
                if(findPathMap(start,goal)!=null){
                    obstacleTypes.add(ObservationType.GROUND);
                    if(findPathMap(start,goal)==null){
                        obstacleTypes.remove(ObservationType.GROUND);
                        return goal;
                    }
                    obstacleTypes.remove(ObservationType.GROUND);
                }

                goal = new Node(new Vector2d(x, y+1));
                if(findPathMap(start,goal)!=null){
                    obstacleTypes.add(ObservationType.GROUND);
                    if(findPathMap(start,goal)==null){
                        obstacleTypes.remove(ObservationType.GROUND);
                        return goal;
                    }
                    obstacleTypes.remove(ObservationType.GROUND);
                }
            }
        }

        return null;
    }

    // Nos dice si una posición esta rodeada por algún monstruo
    private boolean positionSurroundedByMonster(int x, int y){
        if(isMonster(x-1,y)) return true;
        if(isMonster(x+1,y)) return true;
        if(isMonster(x,y-1)) return true;
        if(isMonster(x,y+1)) return true;
        return false;
    }

    // Actualiza todas las listas de gemas.
    private void calculateGems(StateObservation stateObs){
        Node start = new Node(new Vector2d(playerObs.getX(), playerObs.getY()));
        Node goal = null;
        ArrayList<Node> way;
        Observation gem;

        gemsList = getGemsList(stateObs);
        gemsListReachable.clear();
        gemsListBoulderAbove.clear();
        gemsListNotBoulderAbove.clear();

        //Calculamos las alcanzables
        for(int i=0; i< gemsList.size(); ++i){
            goal = new Node(new Vector2d(gemsList.get(i).getX(), gemsList.get(i).getY()));

            way = findPathMap(start, goal);

            if(way!=null && !way.isEmpty()){
                //Calculamos las gemas que tienen una roca encima y son alcanzables
                gem = gemsList.get(i);

                gemsListReachable.add(gem);
                if(isType(gem.getX(),gem.getY()-1, ObservationType.BOULDER))
                    gemsListBoulderAbove.add(gem);
                else
                    gemsListNotBoulderAbove.add(gem);
            }
        }
    }

    // Busca la mejor gema teniendo en cuenta la distancia, si tiene una roca encima o no y si hay monstruos cerca de ella.
    // Si no hay gemas alcanzables las libera y si no se puede liberar entonces libera monstruos para que se choquen y produzcan una gema.
    private Observation bestGem(StateObservation stateObs){
        calculateGems(stateObs);
        Observation obs = null;

        if(!gemsListReachable.isEmpty()){
            if (gemsListNotBoulderAbove.size() > 0)
                obs = nearestGem(gemsListNotBoulderAbove);
            else
                obs = nearestGem(gemsListBoulderAbove);

            if(obs!=null){
                while(positionSurroundedByMonster(obs.getX(), obs.getY()) && (gemsListBoulderAbove.size()>0 || gemsListNotBoulderAbove.size()>0)) {
                    if (gemsListNotBoulderAbove.size() > 0) {
                        gemsListNotBoulderAbove.remove(obs);
                        obs = nearestGem(gemsListNotBoulderAbove);
                    } else {
                        gemsListBoulderAbove.remove(obs);
                        obs = nearestGem(gemsListBoulderAbove);
                    }
                }
            }
        }
        else if(!gemsList.isEmpty()){
            Node n = liberateGems(stateObs);
            if(n!=null)
                obs = new Observation((int) n.position.x, (int) n.position.y, ObservationType.GROUND);
        }
        else {
            int cont = 0;
            for(int i=0; i<getEnemiesList(stateObs).length; ++i)
                cont += getEnemiesList(stateObs)[i].size();

            if(cont>=2){
                Node n = liberateMonsters(stateObs);
                if(n!=null)
                    obs = new Observation((int) n.position.x, (int) n.position.y, ObservationType.GROUND);
            }
        }

        return obs;
    }

    //////////////////////////
    //  Programando el A*   //
    //////////////////////////

    // Calcula el camino después de haber ejecutado el A*.
    private ArrayList<Node> calculatePathMap(Node node) {
        ArrayList<Node> path = new ArrayList<Node>();

        while(node != null) {
            if(node.parent != null) { //to avoid adding the start node.
                node.setMoveDir(node.parent);
                path.add(0,node);
            }
            node = node.parent;
        }

        return path;
    }

    // Nos devuelve si una posición es un obstáculo.
    private boolean isObstacle(int row, int col) {
        if( row<0 || row>=ancho ) return true;
        if( col<0 || col>=alto ) return true;

        for(Observation obs : grid[row][col]) {
            if(obstacleTypes.contains(obs.getType()))
                return true;
        }

        if(isType(row,col-1,ObservationType.BOULDER) && isType(row, col, ObservationType.EMPTY))
            return  true;

        return false;
    }

    // Método que nos devuelve si una posición es un monstruo.
    private boolean isMonster(int row, int col) {
        return isType(row,col,ObservationType.BAT) || isType(row,col,ObservationType.SCORPION);
    }

    // Método que expaande los posibles vecinos.
    private ArrayList<Node> getNeighbours(Node node) {
        ArrayList<Node> neighbours = new ArrayList<Node>();
        int x = (int) (node.position.x);
        int y = (int) (node.position.y);
        int[] x_arrNeig = new int[]{0,    0,    -1,    1};   //up, down, left, right
        int[] y_arrNeig = new int[]{-1,   1,     0,    0};

        for(int i = 0; i < x_arrNeig.length; ++i) {
            if(!isObstacle(x+x_arrNeig[i], y+y_arrNeig[i])) {
                neighbours.add(new Node(new Vector2d(x+x_arrNeig[i], y+y_arrNeig[i])));
            }
        }

        return neighbours;
    }

    // Heurística de nuestro A*.
    private int hEstimatedCost(Node start, Node goal){
        int x = (int) start.position.x;
        int y = (int) start.position.y;
        boolean derecha = ((int) goal.position.x) - x>=0;
        boolean abajo = ((int) goal.position.y) - y>=0;
        int costeEstimado = Math.abs(x- (int) goal.position.x) + Math.abs(y- (int) goal.position.y);

        if ( (x- (int) goal.position.x) != 0 && (y- (int) goal.position.y) != 0 ){    // hay giro
            ++costeEstimado;
        }

        for(Observation obs:grid[x][y-1]) {
            if(obs.getType()==ObservationType.BOULDER)
                costeEstimado += 1000;
        }

        // Posición start
        if(isMonster(x,y)) costeEstimado+=1000;

        // Comprobamos línea horizontal
        if(x > 2){
            if(isMonster(x-2,y)){
                if(!derecha) costeEstimado+=20;
                else costeEstimado+=10;
            }
        }
        if(isMonster(x-1,y)){
            if(!derecha) costeEstimado+=200;
            else costeEstimado+=100;
        }
        if(isMonster(x+1,y)){
            if(derecha) costeEstimado+=200;
            else costeEstimado+=100;
        }
        if(x+2 < ancho)
            if(isMonster(x+2,y)){
                if(derecha) costeEstimado+=20;
                else costeEstimado+=10;
            }

        // Comprobamos línea vertical
        if(y > 2){
            if(isMonster(x,y-2)){
                if(!abajo) costeEstimado+=20;
                else costeEstimado+=10;
            }
        }
        if(isMonster(x,y-1)){
            if(!abajo) costeEstimado+=200;
            else costeEstimado+=100;
        }
        if(isMonster(x,y+1)){
            if(abajo) costeEstimado+=200;
            else costeEstimado+=100;
        }
        if(y+2 < alto){
            if(isMonster(x,y+2)){
                if(abajo) costeEstimado+=20;
                else costeEstimado+=10;
            }
        }

        // Comprobamos las diagonales distancia 1
        if(isMonster(x-1,y-1)){
            if(!derecha && !abajo) costeEstimado+=30;
            else if(!derecha || !abajo) costeEstimado+=20;
            else costeEstimado+=10;
        }
        if(isMonster(x+1,y-1)){
            if(derecha && !abajo) costeEstimado+=30;
            else if(derecha || !abajo) costeEstimado+=20;
            else costeEstimado+=10;
        }
        if(isMonster(x-1,y+1)){
            if(!derecha && abajo) costeEstimado+=30;
            else if(!derecha || abajo) costeEstimado+=20;
            else costeEstimado+=10;
        }
        if(isMonster(x+1,y+1)){
            if(derecha && abajo) costeEstimado+=30;
            else if(derecha || abajo) costeEstimado+=20;
            else costeEstimado+=10;
        }

        return costeEstimado;
    }

    // Algoritmo A* para este problema. Devuelve la ruta óptima entre dos nodos
    // teniendo en cuenta rocas, monstruos, etc. según la heurística.
    private ArrayList<Node> findPathMap(Node start, Node goal) {
        Node node = null;
        PriorityQueue<Node> openList = new PriorityQueue<Node>();
        PriorityQueue<Node> closedList = new PriorityQueue<Node>();

        start.totalCost = 0.0f;
        start.estimatedCost = hEstimatedCost(start, goal);

        openList.add(start);

        while(openList.size() != 0) {
            node = openList.poll();
            closedList.add(node);

            if(node.position.equals(goal.position))
                return calculatePathMap(node);

            ArrayList<Node> neighbours = getNeighbours(node);

            for(int i = 0; i < neighbours.size(); ++i) {
                Node neighbour = neighbours.get(i);
                double curDistance = neighbour.totalCost;

                if(!openList.contains(neighbour) && !closedList.contains(neighbour)) {
                    neighbour.totalCost = curDistance + node.totalCost;
                    neighbour.estimatedCost = hEstimatedCost(neighbour, goal);
                    neighbour.parent = node;

                    openList.add(neighbour);

                }else if(curDistance + node.totalCost < neighbour.totalCost) {
                    neighbour.totalCost = curDistance + node.totalCost;
                    neighbour.parent = node;

                    openList.remove(neighbour);
                    closedList.remove(neighbour);
                    openList.add(neighbour);
                }
            }
        }

        if(!node.position.equals(goal.position))
            return null;

        return calculatePathMap(node);
    }

    //////////////////////////////
    //  MÉTODOS DE DEPURACIÓN   //
    //////////////////////////////

    // Imprime el mapa.
    public void printGrid(ArrayList<Observation>[][] grid){
        String s = null;

        for(int j=0; j<alto; ++j){
            for(int i=0; i<ancho; ++i){
                if(grid[i][j].get(0).getType()==ObservationType.WALL) s = "w";
                else if(grid[i][j].get(0).getType()==ObservationType.EMPTY) s = ".";
                else if(grid[i][j].get(0).getType()==ObservationType.BOULDER) s = "o";
                else if(grid[i][j].get(0).getType()==ObservationType.BAT) s = "b";
                else if(grid[i][j].get(0).getType()==ObservationType.EXIT) s = "e";
                else if(grid[i][j].get(0).getType()==ObservationType.GEM) s = "x";
                else if(grid[i][j].get(0).getType()==ObservationType.SCORPION) s = "c";
                else if(grid[i][j].get(0).getType()==ObservationType.PLAYER) s = "A";
                else if(grid[i][j].get(0).getType()==ObservationType.GROUND) s = "-";

                System.out.print(s + " ");
            }
            System.out.println();
        }
        System.out.println();
    }

    // Imprime lo que se encuentra en la posición (x,y).
    public void printGridpos(int x, int y){
        if (x>=0 && x < ancho && y>=0 && y < alto)
            System.out.println(grid[x][y].get(0));
    }

    // Imprime el camino.
    public void printPath(ArrayList<Node> path){
        for(int i=0; i<path.size(); ++i)
            System.out.print(path.get(i).position.x + " " + path.get(i).position.y + " |");
        System.out.println();
    }
}
