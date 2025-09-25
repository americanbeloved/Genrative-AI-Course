node task_node {
    has name: str;
    has completed: bool = False;
}

walker ToDoManager {
    has task: str;
    has op: str = "add";

    can start with entry;
}

impl ToDoManager.start {
    if self.op == "add" {
        if self.task != "" {
            here ++> task_node(self.task, False);
            print(f"Task added: {self.task}");
        }
    } elif self.op == "complete" {
        for t in [root --> task_node] {
            if t.name == self.task {
                t.completed = True;
                print(f"Marked '{t.name}' as completed!");
            }
        }
    } elif self.op == "list" {
        # nothing to mutate, just list below
    } else {
        print(f"Unknown op: {self.op}");
    }

    # Show all tasks
    for t in [root --> task_node] {
        status = "✅" if t.completed else "❌";
        print(f"{t.name} - {status}");
    }
}

with entry: __main__ {
    while True {
        op = input("Choose operation (add / complete / list / exit): ");

        if op == "exit" {
            print("Goodbye!");
            break;
        }

        task_name = "";
        if op == "add" or op == "complete" {
            task_name = input("Enter task name: ");
        }

        
        root spawn ToDoManager(task_name, op);
    }
}
