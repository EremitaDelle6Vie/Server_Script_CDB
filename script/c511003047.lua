--クリスタルウィング・シンクロ・ドラゴン
function c511003047.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99,nil,nil,nil,nil,c511003047.cfilter,1)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82044279,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c511003047.condition)
	e1:SetTarget(c511003047.target)
	e1:SetOperation(c511003047.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(c511003047.atkcon)
	e2:SetOperation(c511003047.atkop)
	c:RegisterEffect(e2)
end
function c511003047.cfilter(c)
	return c:IsLevelAbove(5) and c:IsType(TYPE_SYNCHRO)
end
function c511003047.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c511003047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local g=Group.CreateGroup()
		for i=1,ev do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc and tc:IsCanBeEffectTarget(e) and te:IsActiveType(TYPE_MONSTER) then
				local loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_LOCATION)
				g:AddCard(tc)
			end
		end
		return g:IsContains(chkc) end
	if chk==0 then
		local g=Group.CreateGroup()
		for i=1,ev do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc and tc:IsCanBeEffectTarget(e) and te:IsActiveType(TYPE_MONSTER) then
				local loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_LOCATION)
				g:AddCard(tc)
			end
		end
		return g:GetCount()>0 end
	local g=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc and tc:IsCanBeEffectTarget(e) and te:IsActiveType(TYPE_MONSTER) then
			local loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_LOCATION)
			local check=false
			g:AddCard(tc)
			if check then tc:RegisterFlagEffect(51102034,RESET_CHAIN,0,1,i) end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	local i=sg:GetFirst():GetFlagEffectLabel(51102034)
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,1,0,0)
	if sg:GetFirst():IsRelateToEffect(te) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	end
end
function c511003047.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	local e3=nil
	if tc:IsType(TYPE_TRAPMONSTER) then
		e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+0x1fe0000)
	end
	local i=tc:GetFlagEffectLabel(51102034)
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	if tc:RegisterEffect(e1)>0 and tc:RegisterEffect(e2)>0 and (e3==nil or tc:RegisterEffect(e3)>0) and tc:IsRelateToEffect(te) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local atk=tc:GetPreviousAttackOnField()
			if atk<=0 then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end
function c511003047.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsLevelAbove(5) and bc:IsControler(1-tp)
end
function c511003047.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	end
end
