#!/bin/bash

echo "🧹 Suppression des ressources conflictuelles..."

# Supprimer le namespace si présent
kubectl delete ns ingress-nginx --ignore-not-found=true

# Supprimer les ClusterRoles, ClusterRoleBindings, IngressClass, Webhook, etc.
kubectl delete clusterrole ingress-nginx --ignore-not-found=true
kubectl delete clusterrolebinding ingress-nginx --ignore-not-found=true
kubectl delete ingressclass nginx --ignore-not-found=true
kubectl delete validatingwebhookconfiguration ingress-nginx-admission --ignore-not-found=true
kubectl delete mutatingwebhookconfiguration ingress-nginx-admission --ignore-not-found=true

# Attendre que le namespace soit complètement supprimé
echo "⏳ Attente de la suppression complète du namespace..."
while kubectl get ns ingress-nginx > /dev/null 2>&1; do
  sleep 2
done

echo "✅ Nettoyage terminé."

echo "🚀 Réinstallation de ingress-nginx avec Helm..."
helm uninstall ingress-nginx -n ingress-nginx 2>/dev/null || true

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace

echo "✅ Installation terminée. Vérifie les pods :"
kubectl get pods -n ingress-nginx

