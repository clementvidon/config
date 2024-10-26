ACHIEVER
================================================================================

Features:

  - This plugin adds custom mappings and functionality to files named
    "achiever", without altering their original filetypes.
  - The plugin is designed to be non-intrusive and efficient.
  - Keep track of your todo history with 'done'.

Example
- side: @achiever update methodology -- tasks semantic definition   = update my todos' tool logic
- side: cleanup todos history                                       = update my todos' data

Todo
================================================================================

TODO doc/ Configuration/Custom Mappings should go after Mappings, and both can not be tagged 'achiever-Mappings'

- side: @achiever fix feature -- syntax highlighting -- should work with other filetype than noesis
- side: @achiever fix feature -- auto-prefix new line from task -- with the cursor before the end of line should not erase the text between the cursor and the end of line
- side: @achiever update doc -- fix conflicts (configuration/custom/mappings section, mappings section, achiever-mappings tag)
- side: @achiever dig -- auto-prefix new line from task details is optional
- side: @achiever add feature -- auto-prefix new line from task details is optional
- side: @achiever add feature -- color for details' prefix (orange? yellow?)
- side: @achiever add feature -- multi-line details can be wrapped from any of their lines
- side: @achiever add feature -- task body completion without the need of underscored?
- side: @achiever update -- turn into a repository and add as a plugin

Done {{{
- 241014 16:00 16:10 side: @achiever DEVIATION update feature -- add light background color for projects @namespace
- 241014 11:15 11:40 side: @achiever update methodology -- task semantic definition
- 241013 19:55 21:05 side: @achiever update feature -- task detail prefix can be modified
- 241013 19:10 19:55 side: @achiever add feature -- auto-prefix new line from task detail
- 241013 18:15 19:00 side: @achiever add feature -- auto-prefix new line from task detail
- 241013 17:45 18:00 side: @achiever cleanup
- 241013 16:25 16:45 side: @achiever cleanup
- 241013 15:45 16:00 side: @achiever add feature -- color for projects @namespace (see noesisLink)
- 241013 10:25 10:50 side: @achiever add feature -- color for prefixed ('@', '#' ?) project names (see noesisLink)
- 241012 22:20 23:00 side: @achiever add feature -- wrap/unwraping details (from multi line to single line and vice versa) { WIP }
- 241012 21:45 22:20 side: @achiever update methodology -- task semantic definition
- 241012 19:20 21:20 side: @achiever update methodology -- task semantic definition
- 241012 14:05 14:25 side: @achiever add feature -- wrap/unwraping details (from multi line to single line and vice versa) {WIP}
- 241010 16:00 16:15 side: @achiever cleanup
- 241010 13:30 15:20 side: @achiever update methodology -- task semantic definition
}}}

Method
================================================================================

Task
----------------------------------------

In addition: ( date / estimates ), DIVERSION, DEVIATION, { feedbacks }

For ease, but also the relevance to the purpose of a to-do list, I never use
upper-cases in an 'achiever' file.

Task Anatomy

  - [timestamp] type: [@namespace] body [-- details]
  1 2           3     4            5    6

  1. A task start with '- '.

  2. A 'todo' task does not have any timestamp.
  2. A 'doing' task as a partial timestamp (task start).
  2. A 'done' task as a complete timestamp (task start + task end).

  3. A task has one of the following types: main, side, life.

  4. A task, depending on its type, must, can or can not have a namespace.

  5. A task has a body.

  6. A task optionally has details.

Tasks timestamp
----------------------------------------

1. A partial timestamp correspond to the current date and time = task start.
2. A complete timestamp correspond to the current time = task end.

An achiever's task is not designed to extend over several days.

Tasks type
----------------------------------------

There are 3 families of tasks:

Main

  Refers to the primary project. Ideally, there should be one main project
  (though multiple are allowed). It’s the project that should receive most of
  your focus.

  E.g. Your company.

  - main: @namespace action [category] target -- details

  The namespace is mandatory for main tasks

Side

  Encompasses side work, such as side projects or any tasks that indirectly
  support your main project. It includes anything that isn’t categorized as
  'main' or 'life.'

  E.g. A language you are learning, a topic you are studying, a side project you
  are building, a tool configuration you are refining.

  - side: action [category] target -- details

  The namespace is optional for side tasks

Life

  Includes all essential life-related tasks life family, friends, health,
  finances.

  - life: action [category] target -- details

  The namespace is proscribed for side tasks


Examples:

- main: @achiever update methodology -- task semantic definition
- side: update phone config -- replace proprietary apps with foss apps
- life: visit movie theater -- beetlejuice with innraz

Tasks namespace
----------------------------------------

Tasks with @project are scoped by this project.

Tasks body
----------------------------------------

  Note that the body part does not contain any 'for', 'with', 'on' words, if
  required, those denote the beginning of the details part.

  - life: hangout -- with innraz
  - life: post -- on twitter

  This will not only improve readibility but simplicity in writing tasks.

  Should not be longer than an action followed by a target (usually 2-3 words).

Tasks details
----------------------------------------

Don't hesitate to develop.
Multi-line support.
Wrap-unwrap details.
