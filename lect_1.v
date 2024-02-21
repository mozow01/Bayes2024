Theorem problem_1 : forall A B : Prop, A /\ B ->  B /\ A .
Proof.
(*intro. intro. intro.*)
intros.
split.
destruct H as [H1 H2].




Qed.
