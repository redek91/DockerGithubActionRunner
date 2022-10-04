using System.Diagnostics;
using System.Runtime.InteropServices;

namespace ScriptWrapper;

public class Program
{
  [DllImport("Kernel32")]
  private static extern bool SetConsoleCtrlHandler(EventHandler handler, bool add);
  private delegate bool EventHandler(CtrlType sig);
  private static EventHandler? _handler;
  private static Process? _loopingProcess;
  private static bool _waitForStop = true;

  public static void Main(string[] args)
  {
    _handler += new EventHandler(ShutdownHandler);
    SetConsoleCtrlHandler(_handler, true);

    _loopingProcess = StartProcess("powershell.exe", "-File start.ps1");
    _loopingProcess.WaitForExit();

    while (_waitForStop)
    {
      Thread.Sleep(500);
    }
  }

  private static Process StartProcess(string program, string arguments)
  {
    var process = new Process();
    var startinfo = new ProcessStartInfo();
    startinfo.FileName = program;
    startinfo.Arguments = arguments;
    process.StartInfo = startinfo;
    process.Start();

    return process;
  }

  private static bool ShutdownHandler(CtrlType sig)
  {
    Console.WriteLine("Exiting system due to external CTRL-C, or process kill, or shutdown");

    _loopingProcess?.Kill();
    StartProcess("powershell.exe", "-File stop.ps1").WaitForExit();
    _waitForStop = false;
    Console.WriteLine("Exit.");

    Environment.Exit(-1);

    return true;
  }

}