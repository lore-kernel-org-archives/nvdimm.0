Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4CD236437
	for <nvdimm@lists.linux.dev>; Wed, 26 Nov 2025 12:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764159120; cv=none; b=iqwZt9x44BThIr3vRqdtH/GmnxzJRnDUcpiwOjM6UovrpW+EHeSP9iif5+Kljy0IqO33zMgZmluB/smdYTTOxsb6rrR5j/vlime9fx+NXlsRRU4XrtY5te/tXSK1rQxT9VkLpjsw1gAlrZfzK8rmwMKMsix+SbUYWfJ8AhtlmqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764159120; c=relaxed/simple;
	bh=uvWHl978Y+rYvpiWI+Kt+Voue06IzDwvCCOmf1Gm9yc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LG6YvSUbawC46C9XGa+INdmCgcHlNuVw/I6Qp4jX2K8MWempXo6srIOOONttpImvccBc5gblhDj6mYgSR8g07in90a1HyC8wKP3JCYihVXlu6CVFA9puXveqiwUTFniOLKrX4dZW+x2BWxLlRwiy4SvaLJC3P7CV37mdPH0l224=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X90djg5s; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X90djg5s"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779a637712so40875815e9.1
        for <nvdimm@lists.linux.dev>; Wed, 26 Nov 2025 04:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764159117; x=1764763917; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cd+1Cagg6P/hQKqKcPtdTLVPLBxLVs3swxXaE6oveBE=;
        b=X90djg5sex2BmH5bf/qcxRks/OJr7vUFoEDvITt+uAIz2crl1L2WcBpbD+JoWfGzCU
         GLMcDBv3oumQq/zIvt9J1bwGnaU1vB0NfTXlo49B3hZC6mD6C2dg8v1h6ypUF5OCQ0kC
         TBR2//2tOOg2Tzafg31L615xSPmQZIf9KrV3YfqKZY24ZDic7h7SGcZIGo31/VbHyzp1
         dzeAF80aGbYda0K4Lv+Rf4qh7q/dAs51N5BnDX1Mtk4H3HLoCdAgcmFlrdCkIgGIhE0Y
         F0iTi1/FE9Pgjjc4lR0C8zklqQL8ntFSXsNq+UmoCzIDlbwMB6w7+HWVFGiEf7Q1XGht
         NNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764159117; x=1764763917;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cd+1Cagg6P/hQKqKcPtdTLVPLBxLVs3swxXaE6oveBE=;
        b=MYFRuTPs/hpMoMSG9QLJFPk3zAvMgfZXiycAkk4/lTJ4RQhyNdVE0i7ZDn+0+YC+MG
         GJe3LoYxz5sjTZqWajAlBpyQMQhZ37i+BIxqLExdbV8VyhfU7Ih1Vaus9COPr+T4OYfN
         fDXnR5ZP5CcWo76BdYOQhijbzQtEp/3/pJILS0ZSh2lscEM9tpvHH+4iO3yVV9h5lH+0
         IRQyEQHpEr9pzeOeGWklmdH0HL4SuyzpwUYJe7Ehqd3UopxS8GgO+OoVFxudEXQ1dvLQ
         zClivKbFLjVTa52xq6bJQ9P5MpATEn2MS3lXbE2QXCV2Meh590wCm9eBACXq/d2b/uEf
         Oo7A==
X-Forwarded-Encrypted: i=1; AJvYcCWuvWryfmULB+A4HLpbW7xvWTztckdvzsFWkrxZCAv64bq0Io6CzVZvtViqUsevMhKFspC37qw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdNqWS0qS6zy5drRNoC2AJGTYQS0XIENoG2xeFPIPiJy8walKi
	SQkEnXJxsPl5R78oNlw/sQ3mtLqk2Oe17xVgKc5Mknu82c8xbEtKKbuSZ9UnNBZzR+A=
X-Gm-Gg: ASbGncu0WlJpl9AdpyfxclB9RM8VGYmmje36PWSMAkjcxkpEv9Nl9wy/iHIgUsQK35O
	utGK4GGHU/21ZkdOyeA2TjfCCMZtf5N2KD1DTmwWB8zqhMzyX4GEwrhho2vIFZgI+sEcw+HO9ZU
	1SdEz92HM8wTWwmlu7v06EvF1zo+5ilIAaqAf5tnZP3E4+h3uHi/TEApPW57RD6EwToP6W6MYBU
	pKLyD3NAlhssnDS+NW7i8Y18ZTSnendj8hbzQrQGxGbcJ2x7uQnGzP/2uNq/x7QTFoe2L304Ted
	ZpQIKHxdDj4evQhONPBI98IDKIJgM6VJtQ5VADAWv4Hmq2xKUw+Ey/++/j2k99ZEcugWZHQqN0D
	CS4dfUfQ2iBRkWTfKXw2YzfiDySP0bEzokSlowL66KjU9IW2aYmplArGJ4hFsNQzX8zCTgnPVRf
	F2d2ykUa4J1tUfrgny
X-Google-Smtp-Source: AGHT+IFWu9W4TOiqyvkdf1aDEOHe4E+V/s2R/oq+X48vwv7Tx6mXyt3EVJ8/GOWx1Thn6yZchN5usA==
X-Received: by 2002:a05:6000:1846:b0:42b:3b45:7197 with SMTP id ffacd0b85a97d-42cc1d0c89dmr17865163f8f.42.1764159117033;
        Wed, 26 Nov 2025 04:11:57 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42cb7f363c0sm41102732f8f.18.2025.11.26.04.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 04:11:56 -0800 (PST)
Date: Wed, 26 Nov 2025 15:11:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH next v2] nvdimm: Prevent integer overflow in
 ramdax_get_config_data()
Message-ID: <aSbuiYCznEIZDa02@stanley.mountain>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The "cmd->in_offset" variable comes from the user via the __nd_ioctl()
function.  The problem is that the "cmd->in_offset + cmd->in_length"
addition could have an integer wrapping issue if cmd->in_offset is close
to UINT_MAX .  Both "cmd->in_offset" and "cmd->in_length" are u32
variables.

Fixes: 43bc0aa19a21 ("nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
v2: Ira Weiny pointed out that ramdax_set_config_data() needs to be
    fixed as well.

 drivers/nvdimm/ramdax.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
index 63cf05791829..954cb7919807 100644
--- a/drivers/nvdimm/ramdax.c
+++ b/drivers/nvdimm/ramdax.c
@@ -143,7 +143,7 @@ static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
 		return -EINVAL;
 	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
 		return -EINVAL;
-	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
+	if (size_add(cmd->in_offset, cmd->in_length) > LABEL_AREA_SIZE)
 		return -EINVAL;
 
 	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, cmd->in_length);
@@ -160,7 +160,7 @@ static int ramdax_set_config_data(struct nvdimm *nvdimm, int buf_len,
 		return -EINVAL;
 	if (struct_size(cmd, in_buf, cmd->in_length) > buf_len)
 		return -EINVAL;
-	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
+	if (size_add(cmd->in_offset, cmd->in_length) > LABEL_AREA_SIZE)
 		return -EINVAL;
 
 	memcpy(dimm->label_area + cmd->in_offset, cmd->in_buf, cmd->in_length);
-- 
2.51.0

