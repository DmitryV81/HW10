Домашняя работа по теме "Управление процессами"

Задание:

Написать свою реализацию ps ax используя анализ /proc

Ход выполнения домашнего задания.

Для реализации задания, в скрипте необходимо анализировать файлы /proc/[PID]/stat

Пример содержимого файла stat:

```
[root@web ~]# cat /proc/2/stat
2 (kthreadd) S 0 0 0 0 -1 2138176 0 0 0 0 0 0 0 0 20 0 1 0 5 0 0 18446744073709551615 0 0 0 0 0 0 0 2147483647 0 18446744072433201317 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
```

Значения в файле разделены пробелами. Для решения поставленной задачи нам необходимо получить значения в порядке их следования в файле:

1 PID процесса

2 Имя исполняемого файла

3 Статус:
  R  Running

  S  Sleeping in an interruptible wait

  D  Waiting in uninterruptible disk sleep

  Z  Zombie

  T  Stopped (on a signal) or (before Linux 2.6.33)
                         trace stopped

  t  Tracing stop (Linux 2.6.33 onward)

  W  Paging (only before Linux 2.6.0)

  X  Dead (from Linux 2.6.0 onward)

  x  Dead (Linux 2.6.33 to 3.13 only)

  K  Wakekill (Linux 2.6.33 to 3.13 only)

  W  Waking (Linux 2.6.33 to 3.13 only)

  P  Parked (Linux 3.9 to 3.13 only)


6 ID сессии

7 Терминал

8 ID группы процессов

19 Nice. Принимает значения от 19 (самый низкий приоритет процесса) до -20 (самый высокий приоритет процесса)

20 Количество потоков

В скрипте определены функции:

#PID_F() - выводит ID процесса. Upgrade: заменил просто на вывод переменной $id

TTY_F() - выводит значение TTY

STAT_F() - выводит статус процесса

COMMAND_F() - выводит cmdline

Каждая из этих функций вызывается в цикле, который перебирает значения PID, взятые из каталога /proc

```
for i in $PID
    do
    if [ -e /proc/$i/stat ]; then
    printf "%5d %-6s %-7s %s\n" $i $(TTY_F) $(STAT_F) $(COMMAND_F);
    
    fi
    done
```

Стоит обратить особое внимание на функцию STAT_F(). В итоге её работы мы получаем строку вида:

```
$State$Nice$Lead$Thread$VMLPages$Foreground
```

Расшифровка статусов:

  <    high-priority (not nice to other users)

  N    low-priority (nice to other users)
  
  L    has pages locked into memory (for real-time and custom IO)
  
  s    is a session leader
  
  l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
  
  "+"    is in the foreground process group

Пример вывода скрипта показан в файле ps.txt
