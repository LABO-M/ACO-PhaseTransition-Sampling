# ACO on network

- \( t = 1, \ldots \)：アリのインデックス。アリ \( t \) は時刻 \( t \) にネットワークに入る。
- アリ \( t \) がネットワークに入った後のアリ \( i \) の入次数と出次数をそれぞれ \( k^{OUT}_{i}(t) \)、\( k^{IN}_{i}(t) \) と表す。
- ノード \( i \) の次数は \( k_{i}(t) = k^{IN}_{i}(t) + k^{OUT}_{i}(t) \) である。

## 初期条件

- \( r + 1 \) の完全ネットワークから始める。
- アリ \( i = 1, \ldots, r + 1 \) は \( k^{IN}_{i}(r + 1) = r \) の入次数と \( k^{OUT}_{i}(r + 1) = (r + 1) - i \) の出次数を時刻 \( t = r + 1 \) で持つ。

## ネットワークの進化

- アリのネットワークの進化は \( \{k_{i}(t)^{IN}, k_{i}(t)^{OUT}\} \) の集合によって決定され、\( t = r + 2 \) からのエージェントたちが始める。
- \( t \geq r + 2 \) のアリは時刻 \( t \) にネットワークに入り、既存のノード \( s = 1, \ldots, t - 1 \) の中から \( r \) エージェントを選ぶ。
- \( k^{IN}_{i}(t) \) はアリ \( i \) がネットワークに入った時刻 \( t = i \) 以降変わらない。
- \( k^{OUT}_{i}(t), j < i \) はアリ \( i \) にエージェント \( j \) が選ばれると1増加する。

# 人気度（Popularity）

- アリ \( t \) がネットワークに入った後のアリ \( i \) の人気度 \( l_i(t) \) は次のように定義される。

  \[
  l_i(t) = k^{IN}_i + \omega k^{OUT}_i(t) = r + \omega k^{OUT}_i(t), -1 \leq \omega < \infty
  \]

- 時刻 \( t = i \) でアリ \( i \) からリンクを受け入れることができるアリ \( j \) の数 \( r' \) は、アリ \( j \) の人気度が 0 より大きいアリの数と定義される。

  \[
  r' = \# \{i | l_i(t) > 0, j = 1, \ldots, t \}
  \]

- 出次数の総和は以下のように表される。

  \[
  \sum_{i=1}^{t} k^{OUT}_i(t) =
  \begin{cases}
  \frac{1}{2}r(r + 1) + (t - (r + 1))r = {r(t - (r + 1)/2)} & t \geq r + 1 \\
  \frac{1}{2}t(t - 1) & t \leq r + 1
  \end{cases}
  \]

  \[
  \sum_{i=1}^{t} l_i(t) = rt + \omega \sum_{i=1}^{t} k^{OUT}_i(t) \geq r(r + 1)/2 > r, \text{ for } (r \geq 1, \omega \geq -1) \rightarrow r' \geq r
  \]

- \( \omega = -1 \)：拡張ラティスケースにおいて、\( k^{OUT}_i(t) \) は次のように定義される。

  \[
  k^{OUT}_i(t) =
  \begin{cases}
  r & i = 1, \ldots, t - r \\
  t - i & i \geq t - r
  \end{cases}
  \]

# ネットワークの進化

- \( \Delta k^{OUT}_i(t) \) は \( k^{OUT}_i(t + 1) - k^{OUT}_i(t) \) であり、\( \{0, 1\} \) のいずれかの値を取る。

  \[
  \sum_{i=1}^{t} \Delta k^{OUT}_i(t) = \sum_{i=1}^{t} (k^{OUT}_i(t + 1) - k^{OUT}_i(t)) =
  \begin{cases}
  r & t \geq r, \omega \geq -1 \\
  t & 1 \leq t \leq r
  \end{cases}
  \]

  \[
  \sum_{i=1}^{t} k^{OUT}_i(t) = r(t - (r + 1)/2)
  \]

- \( P(\Delta k^{OUT}_i(t) = 1) \) は \( r \) に \( \frac{\text{Max}(l_i(t), 0)}{\sum_{i=1}^{t} \text{Max}(l_i(t), 0)} \) を掛けた値である。

  \[
  \sum_{i=1}^{t} l_i(t) =
  \begin{cases}
  rt(1 + \omega) - \frac{\omega}{2}r(r + 1) & t \geq r, \omega > -1 \\
  t(r + \frac{\omega}{2}(t - 1)) & t \leq r + 1
  \end{cases}
  \]

- リンクマトリックス（アリ \( t \) からアリ \( i \) への指向性ネットワーク）は \( L(t, i) \) で表され、次のように定義される。

  \[
  L(t, i) =
  \begin{cases}
  1 & \text{if } \Delta k^{OUT}_i(t - 1) = k^{OUT}_i(t) - k^{OUT}_i(t - 1) = 1 \\
  0 & \text{otherwise}
  \end{cases}
  \]

  \[
  \sum_{i=1}^{t-1} L(t, i) = r
  \]

# アリの意思決定とポリアの壺過程

- \( N \) 個の二択問題がある。
- アリ \( t \) の回答は \( X(j, t) = \{0, 1\}, j = 1, \ldots, N \) として表され、アリ \( t \) のスコアは次のように計算される。

  \[
  TP(t) = \sum_{j=1}^{N} X(j, t)
  \]

- アリ \( t \) は、\( L(t, i) = 1 \) のときにアリ \( i \) のスコアに基づいて意思決定を行う。

  \[
  X(j, t + 1) \sim \text{Ber}(p(j, t))
  \]

  \[
  S(t) = \sum_{s, L(t+1,s)=1} TP(s) = \sum_{s=1}^{t} TP(s) \Delta k^{OUT}_s(t)
  \]

  \[
  S(j, t) = \sum_{s, L(t+1,s)=1} X(j, s) TP(s) = \sum_{s=1}^{t} X(j, s) TP(s) \Delta k^{OUT}_s(t)
  \]

  \[
  Z(t) = \frac{S(t)}{rN}
  \]

  \[
  Z(j, t) = \frac{S(j, t)}{S(t)}
  \]

  \[
  p(j, t) = (1 - \epsilon) \cdot \frac{Z(j, t)^a}{Z(j, t)^a + (1 - Z(j, t))^a} + \frac{1}{2} \epsilon = f(Z(j, t))
  \]

  \[
  f(x) = (1 - \epsilon) \cdot \frac{x^a}{x^a + (1 - x)^a} + \frac{1}{2} \epsilon
  \]

## 平均場近似（Mean field approximation）

- \( E_{net}(\Delta k^{OUT}_i(t)) \) は \( P(\Delta k^{OUT}_i(t) = 1) \) と等しく、次のように表される。

  \[
  E_{net}(\Delta k^{OUT}_i(t)) = r \cdot \frac{\text{Max}(l_i(t), 0)}{\sum_{i=1}^{t} \text{Max}(l_i(t), 0)} \approx r \cdot \frac{l_i(t)}{D(t)} \text{ for } t \geq r
  \]

  \[
  D(t) = \sum_{s=1}^{t} l_s(t) = rt(1 + \omega) - \frac{1}{2} \omega r(r + 1)
  \]

  \[
  S(t) = \sum_{s, L(t+1,s)=1} TP(s) = \sum_{s=1}^{t} TP(s) \Delta k^{OUT}_s(t)
  \]

  \[
  \tilde{S}(t) = E_{net}(S(t)) = \frac{\sum_{s=1}^{t} r \cdot l_s(t) TP(s)}{D(t)}
  \]

  \[
  S(j, t) = \sum_{s, L(t+1,s)=1} X(j, s) TP(s) = \sum_{s=1}^{t} X(j, s) TP(s) \Delta k^{OUT}_s(t)
  \]

  \[
  \tilde{S}(j, t) = \sum_{s=1}^{t} l_s(t) X(j, s) TP(s) = \frac{\sum_{s=1}^{t} l_s(t) X(j, s) TP(s)}{D(t)}
  \]

  \[
  E_{net}(S(j, t)) \approx \tilde{S}(j, t)
  \]

## 決定のプロセス（Decision Making）

- \( X(j, t + 1) \) の確率は次のように更新される。

  \[
  X(j, t + 1) \sim \text{Ber}(p(j, t)), p(j, t) = (1 - \epsilon) f(\tilde{Z}(j, t)) + \frac{1}{2} \epsilon, \tilde{Z}(j, t) = \frac{\tilde{S}(j, t)}{S(t)}
  \]
