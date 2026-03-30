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
Deprecated Method 260224 {{{
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
}}}

TASK FORMAT GUIDELINE
----------------------------------------

FORMAT
- work: @project... verb_object [> scope...] [( nature )] [-- execution]

LANGUAGE
- all tasks must be written in english
- applies to: verb_object, >, (), --

REDUNDANCY RULE

- do not repeat information already present in the verb_object
- do not duplicate information between verb_object, >, and ()
- avoid duplicating domain in:
  - drill-down (>)
  - commit scope

Examples:

- reorganize_docs > docs
  → redundant (docs already in verb_object)

- docs(docs): ...
  → redundant (type and scope duplicate information)

- reorganize_docs ( structure )
  → correct

- docs: reorganize documentation tree
  → correct

---

VERB_OBJECT
- snake_case, imperative
- represents a stable, reusable intention
- do not include technical details
- use a fixed canonical set

RULES
- do not create new verbs if an existing one fits
- specialize with '>' (never with the verb)
- choose the most appropriate existing verb; avoid defaulting to generic verbs like refactor_code

CANONICAL SET
- can be defined per project/context

---

DIMENSIONS
- @project : context
- verb_object : main intention
- > : scope (where)
- () : execution nature (how)
- -- : concrete action

---

PROJECTS
- multiple @project allowed
- order is significant: LEFT → RIGHT defines hierarchy
- from most abstract → most concrete

- leftmost @ = global context (WHY)
- next @ = project or execution context (WHERE)
- optional deeper levels allowed if useful

RULES
- never reorder @ randomly
- always keep consistent ordering across all entries

ex:
@employment @devbarometer
→ employment context → devbarometer project

---

DRILL-DOWN (>)
- used only for scope (never action)
- generic → specific
- non-exhaustive, only if useful
- do not use '>' if the scope is already implied by the verb_object

ex:
refactor_code > api
refactor_code > backend > api

---

NATURE ()
- describes execution context (paradigm, constraint, environment, artifact, mode)
- free-form, not an action
- must be meaningful and add contextual precision
- must include a space after '(' and before ')'

ex:
( client/server + iac )
( async batch )
( readme )

---

EXECUTION (--)
- concrete task or commit (See: `./docs/convention/commit_message_convention.md`)
- source of truth for actual work (most precise level)
- MUST contain the most specific and actionable description

ex:
-- feat(api): add endpoint
-- write tradeoffs

---

RULES
- 1 line = 1 main intention
- verb_object + > = stable frame
- verb_object defines the umbrella intention (not every -- line)
- -- = exact action
- do not duplicate action in '>'

---

GOOD EXAMPLE
work: @devbarometer refactor_code > api ( client_server + iac )
  -- feat(api): add topic read endpoint
  -- docs: write tradeoffs

---

ANTI-PATTERNS
- refactor_code ( backend api )
  → mixing scope and nature

- refactor > api
  → invalid verb

- refactor_code > api ( fix bug )
  → action inside ()

- refactor_code -- improve code
  → too vague

---

MENTAL MODEL
@ → context
verb_object → intention
> → where
() → how
-- → action
