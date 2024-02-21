Theorem problem_1 : forall A B : Prop, A /\ B ->  B /\ A .
Proof.
(*intro. intro. intro.*)
intros.
split.
destruct H as [H1 H2].
exact H2.
destruct H as [H1 H2].
exact H1.
Show Proof.
Qed.

Theorem problem_2 : forall A B C : Prop, (A /\ (B \/ C)) -> 
(A /\ B) \/ (A /\ C).
Proof.
intros.
destruct H as [H1 H2].
(*esetszétválasztás*)
elim H2.
intros.
left.
split.
auto.
auto.
intros.
right.
auto.
Qed.


(*Currying*)
Theorem problem_3 : forall A B C : Prop, (A /\ B -> C) -> (A -> B -> C).
Proof.
intro.
intro.
intro.
intro.
intro.
intro.
apply H.
split.
assumption.
assumption.
Defined.

(*un-Currying*)
Theorem problem_4 : forall A B C : Prop,  (A -> B -> C) -> (A /\ B -> C).
Proof.
intros.
apply H.
destruct H0.
apply H0.
destruct H0.
apply H1.
Show Proof.
Defined.

Theorem problem_5 : forall A B C : Prop, ((~ A) \/ B) 
-> (A -> B).
Proof.
intros.
elim H.
intros.
contradiction.
auto.
Show Proof.
Defined.

Theorem problem_6_1 : forall A B C : Prop, (A \/ ~ A) -> (A -> B)
-> ((~ A) \/ B).
Proof.
firstorder.
intros.
elim H.
intros.
contradiction.
auto.
Show Proof.
Defined.
















