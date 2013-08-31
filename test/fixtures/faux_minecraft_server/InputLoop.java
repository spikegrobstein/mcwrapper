import java.io.*;
import java.util.Scanner;

public class InputLoop {

  public static void main(String[] args) {
    String input = "";
    Scanner stdin = new Scanner(System.in);

    System.out.println("Faux Minecraft Server starting up...");

    while( ! input.equals( "stop" ) ) {
      System.out.print("> ");
      input = stdin.nextLine();

      System.out.println("Got: " + input);

      if ( input.equals("help") ) {
        System.out.println("Type 'stop' to stop.");
      }
    }

    System.out.print("Shutting down... ");

    try {
        Thread.sleep(2000);
    } catch(InterruptedException ex) {
        Thread.currentThread().interrupt();
    }

    System.out.println("Done!");

    System.exit(0);

  }
}
