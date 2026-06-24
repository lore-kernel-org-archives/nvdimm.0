Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC8A3328FA
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 18:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782327568; cv=none; b=LVEd55KX1sESVZaZr40oxgnKK06bLC8FBqizOpRWFayLuf5vXU4rmJTLGTUaZdyOCf4NjEQhJVnsed0Bly4bmgUcyHG5zeejpOrdWTl1FDnYCfuudKVQY4ysvPsDjPDRDGrPcq3nGhs/GY1WiRsWbVPcGEnPnluNTlmL+qrd83o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782327568; c=relaxed/simple;
	bh=zIstxXEsUAI+ajGpmVV2P35LQJBkQnh0RLzi3QQJ3UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFECioxzsZT8H0RPl6AznBZ62z/Wgafyo3CB7B3MW0w0aILJiXB+KN6lThZb6yOUEAoYPqxKISa6vMwRtjDPoHlmEiIOyyVPqjNXwIR2Z/MY3PJNygrJtgB3toCYEYGrZsXDPcfm1wj38/wvTBA9B1FvYaef3P5a+NiVSqUrIk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=c4RNTpSY; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="c4RNTpSY"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51a13ceb03bso16258661cf.2
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 11:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782327566; x=1782932366; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pT11NgXcnMUuSA5mrycomy1NHWdVYPAjx4vn9wcSoDQ=;
        b=c4RNTpSYfKToP3wrggyhnbRyJVWiXEcxg+UcorSwxGzMVXZfd0CKXZcRZ0fIc+2+hR
         T+FJ9T9Hc+rTg8Om4DPGE05OUPpAtI9PUE/CRs8nGQw9oV8mntUnzMlgC+JKoLK8786X
         aBpaudBXNwB3Swde4W8HpIyQjcZbxKjSKV32rLESe4HNp0ualM0EqzEb0jb0WHTDIOKi
         gMxeHkCoUIIniPaqEbJmWciR3mzJWMetSMo/CiRG6SdG8fMb16R2H/xKog7yV76SPSsC
         Yky9ZWD2E6cHdyntoVtdtkXYTxGpVqzqvdZPtbWZp0lFH8P7Gsn2mvOeiULif5hRuPiZ
         iqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782327566; x=1782932366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pT11NgXcnMUuSA5mrycomy1NHWdVYPAjx4vn9wcSoDQ=;
        b=XA1sSp+1la0zuT5cRXsn1CsHs/woOewwAChm+Unh6Vd9rfQHd2diVpQ8qwlnUR+MGk
         yW4DpH4rx77YJ1CiCn+OayWvIrOMiSpJX7KSwZ8+umWMO/TAUII8p8Bqln+7MMtd6zbz
         SfL6i8+Cu4/LlU8qymasISVVp8Q+7YYihne5TxkCz1wvGcwefHQPPIOk8I2Le1z9PaiG
         2su7ogbkoTXHKk1snBgB3vl9kR762wIHsD5rta4JwtnHFJqViF0N5q0ZDuHaFB9hW07e
         9zuP3tdVNkjKUrZZEzz9/3SsKW5cD2fjSXnZEngUC2tDjhBk8OzHgTVvh3Ja1XEFq+49
         l1sQ==
X-Forwarded-Encrypted: i=1; AFNElJ+u0ahinFPrG61OIo6FYmxFPgiwfkjFVzpSyGOTVNKLTOilvBaVxvtFvD4agDGO1OoEm4bj05g=@lists.linux.dev
X-Gm-Message-State: AOJu0YygHP5vRf9zCGfsrT6ff+3aBedCVB61RzBynG22zWiaaBh/1GCG
	U1qbTo44rXi8xG0e9C7OldkK78jgPgj+eU4HULziHJo2OuS8aP0sQK5Ku5M9LiMRpYw=
X-Gm-Gg: AfdE7cmT2KCjwq7sl+yNTJtfDXoswJCn53rlXVo4XhqLpMZpUuGft7IdsBMnFYOm49k
	1Q5CiqTQ7WxziRHPse6njgIL7kShDdBlpIz6KZT2c6BXXTQlWaVotO9EXxPqWG63qQdfh1L/1r8
	qIlugg6nUeUDfEIItJs/uLu+yT6IlVTX7ylcyn/98Ds2Cob7hrTpzNAXAcsPO+8jhwL5/YDz60X
	m0A1uj16dpel6jR7Z0STiBybStQP4Ao2+kBvwBtnrn+90j4IVoDV8fvmdpwxlfBJyC/sYXv6uLR
	M2PYmhoJ8v9VVL0fABqOY2OvH+DTYRYlSD8FiKGcKYh7aE3tqCTtCxKu6c4PipoTdPkHATTs7pu
	uyasUV+0wD1SkmvyKIo+AiJYnhYYceCn6/1SPcMBbxORgf3NHZj/lfXf/qqgGjprY7brY9fPcC1
	OFKgazayAawoHW44DBb7l2Exp3MoWXqJ4nVNHWswaKY+x5Ely54pbsluHivuAuT16dFC93
X-Received: by 2002:ac8:5ac3:0:b0:519:5836:2f04 with SMTP id d75a77b69052e-51a61af8223mr67843231cf.8.1782327565960;
        Wed, 24 Jun 2026 11:59:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f018898sm161022456d6.7.2026.06.24.11.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 11:59:25 -0700 (PDT)
Date: Wed, 24 Jun 2026 14:59:20 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org, nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
	apopple@nvidia.com
Subject: Re: [PATCH v5 0/9] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ajwpCOSGapenRPsu@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>

On Wed, Jun 24, 2026 at 10:57:35AM -0400, Gregory Price wrote:
>... snip ...

Disregard, there are a few unaddressed Sashiko comments, I'm just going
to respin this.  Will wait until after the merge window closes for v6.

The rough shape of things should still hold w/ prior feedback.

~Gregory
