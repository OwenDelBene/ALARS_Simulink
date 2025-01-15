function q = normalizeq(q)
n = norm(q(1:4));
q(1:4) = q(1:4) / n;
end 