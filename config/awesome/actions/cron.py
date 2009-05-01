import time
import threading
import heapq
import sys
import os


class Task(object):
    "Cron task object"
    def __init__(self, action, timestamp):
        self.timestamp = timestamp
        self.do_time = time.time() + self.timestamp
        self.action = action

    def _do(self):
        os.system(self.action)

    def do(self):
        self.do_time += self.timestamp
        threading.Thread(target=self._do).start()

    def __repr__(self):
        return "<Task:%s;%d;%d>" % (self.action, self.timestamp, self.do_time)

    def __lt__(self, o):
        return self.do_time < o.do_time

    def __gt__(self, o):
        return self.do_time > o.do_time


class Cron(object):
    "Simple Cron class"
    def __init__(self):
        self.heap = []

    def add_task(self, task):
        "add new task"
        heapq.heappush(self.heap, task)

    def run(self):
        while True:
            task = heapq.heappop(self.heap)
            next_task_time = task.do_time - time.time()
            if next_task_time <= 0:
                task.do()
            else:
                time.sleep(next_task_time)
            self.add_task(task)


def load_tasks(cron, tfile):
    for line in open(tfile):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        tm, action = line.split(" ", 1)
        t = Task(action, float(tm))
        cron.add_task(t)


if __name__ == "__main__":
    if not len(sys.argv) == 2:
        sys.exit("Usage:  %s <configuration>" % sys.argv[0])
    cron = Cron()
    load_tasks(cron, sys.argv[1])
    # run each task
    time.sleep(2)
    for task in cron.heap:
        task.do()
        time.sleep(0.2)
    cron.run()
