# Validação antes da publicação — Ponto Resgatécnica

## Estado desta entrega
- Branch de trabalho: `admin-dashboard-test`
- Branch estável: `main`
- Backup do código: `pre-publish-backup-2026-11-08`
- A versão estável não foi alterada por esta entrega.
- A comparação atual mostra 5 commits à frente da `main`, sem commits exclusivos atrás.
- A validação visual em navegador real ainda está pendente.

## Alterações incluídas
- Painel administrativo separado em `admin.html`.
- Link para o painel exibido somente para perfil com papel `admin`.
- Verificação independente de papel administrativo no próprio painel.
- Consultas de vendedores, pontos, visitações e trilha de auditoria.
- Correções para evitar exclusões implícitas durante sincronização.
- Fluxos de criação/exclusão de visita e remoção de foto com tratamento de falhas.

## Checklist obrigatório antes de mesclar em main
- [ ] Validar login de administrador (João).
- [ ] Validar login de vendedor (Walter).
- [ ] Confirmar que vendedor não acessa painel nem por URL direta.
- [ ] Confirmar que administrador visualiza os dados permitidos.
- [ ] Criar ponto e confirmar persistência após recarregar.
- [ ] Registrar visita com foto e confirmar persistência.
- [ ] Excluir visita e confirmar que a linha e a foto são tratadas corretamente.
- [ ] Simular falha de sincronização e confirmar que não há perda silenciosa.
- [ ] Testar filtros, histórico, compartilhamento e exportação.
- [ ] Testar layout em celular e desktop.
- [ ] Rever os avisos de segurança do Supabase.
- [ ] Fazer backup verificável do banco e dos arquivos de Storage.
- [ ] Confirmar restauração/retorno antes da publicação.

## Segurança — pendências identificadas
- Advisor sinalizou `public.is_admin()` como função SECURITY DEFINER executável por usuários autenticados. A correção deve preservar as políticas RLS e os gatilhos de auditoria; não remover permissões sem testar.
- Advisor sinalizou que a proteção contra senhas comprometidas está desativada. Ativar pela configuração de Auth e validar login/fluxo de senha.

## Regra de publicação
Não mesclar este PR em `main` até que os itens obrigatórios estejam verificados. A branch de testes e o backup devem permanecer disponíveis durante a validação.
