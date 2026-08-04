Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D2646EC6D
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 15:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858327; cv=none; b=C7yxvdrMe/Fy66XtA3zLN5bZ/7IzIv8RnDRmFNBgJWWembYJV428+q2ewPTjWdDpwTsUlTqNB3Afw4T/QDYGPD/wbDvITlAiYCTie/PQDBsEW0rbs4Q3idcf+fo+dhqenkVXnhnBPs4eIfd6bZFPAoojUS3DIJGn6UDFpgP6PKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858327; c=relaxed/simple;
	bh=udcDnCZOafJFJBg/CawTNl6gae2dFtyKioVGErWlQrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWXoV8qQmf21s3EtYoT1WVIDtntq11MVcok1nU7daCgbGJbkptjAGxZNgZda1m8mP69UZqqFgklrLumV08elrHtAKJHJVGY3bfcntyroB2h/CaxktEwI2sd91QjH9/T2UDchBr5Bd3xJI974J+aoHuD/aPb/Ezd9zr7CKuQF6DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=NtH8M+lC; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="NtH8M+lC"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-934956bee57so415404985a.2
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785858322; x=1786463122; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EwAZOjeHlqWn9v6/BYYDkI9dqxumArr6QgC+CpKgPx8=;
        b=NtH8M+lCSnpUgzlR6H9nCU9bjzjvUXhBkhgE7zxnZSnfCmj8US+c5PCUh1b/ZYMHD4
         W/WnyNaiHi112i7QOjoiGqNKUxKhhur2bvjWeUFtqzrjOiG0MVI43CKZXUhU+yPR3HtD
         RZR2BB/7eFmzCEifAPbKEXyeHLtMCcFRpIXyv2jWFK+pKLeEmPnKt3BDvItDdQCIlsnS
         dTYlSrN4BpfMMdG8NwJB1DHriM/XGS6a29goipcHmSQVtRrKQ/zj7ImrCUxcGXX2yHNN
         fVDUV7K9/fFKETb5QOjXW+01m9bx4G6N/gVhpS9vkeTVMlgrZb2Nt6wsOdCSYfSfHT5m
         4+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785858322; x=1786463122;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EwAZOjeHlqWn9v6/BYYDkI9dqxumArr6QgC+CpKgPx8=;
        b=moMQiiihLSx3UCRY666GkALqQ5Qkidv0R5Q8l+kYu2Y4etrC4DlzjuN6lEJEA4LJXg
         qOnSz4KNjO0YT0mcdDK29/ntjd3TL69OqSA1CccwguGWBjuInHhLJOU6Cgd1pENEot6p
         X3f/qaWWehwAjISAfmjo1/KFzvAvJJltlj8MGpXUzAcgEx5cP7IDz1Om6Z3Gem6TCINM
         wNVAI1oOF8uC34vmTuhqOy5Ey1KKyp9nfdEuK5Om+q0ciA6qhJUL36A7CEK5J0SjkFmk
         tU5dclw9TfJJNmU8ASRMLTdwo+xB2EA+zRs9YJ0eYUcD7qych0ZU6hL7FjTJzri8cVC0
         TTEw==
X-Forwarded-Encrypted: i=1; AHgh+Rr29V3dHD1CO4qGoDHKyH8Euni9Fyovc0emWNZwJJzLNBdlOqjaUbFtB/kaaEpWdJQApZHhIVc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1smJ5V0vUFB0o96UAjxbPyoV/r9hlOLz5t+w4IVCLipC9JJBb
	r9WG2ffitbHzKQUSOWOy1Vm3pz9TuBbwuJQzSTRGH5/4MEvPVxHx0Zvs3xFfk4CcpV4=
X-Gm-Gg: AR+sD126HIXfdAJwOJM/JafrXR9J9Cz6VXTTCHS1RUpacfDnxiq3J74nRAZZyqhEUqt
	j+ntrsPXtrqybdBsheHMDlud+n5Y6yyjFb3cztRS5v1XW1/15rqzUlh46EARnAP2SvEMl8KYJp0
	PT1mEPWPf1SCaqm1m4hybav0oHydFDAGdj59R54hIJo+G8WiXUtg8FPCoVvDafB8n2GMT9vuc0+
	q2vDvOvYGW64mtAKUQgcPyCUP+SbcpNKBOtNYGRtwUcJp7LL1Y4rHS42Q38jJ/K9Nvl2MiOpMw4
	Xyh1plopuUoMyMkiQhQcPq521ZBYIjKmfb17Qc8I/1O8KP/e2HT8NoAYh0okKXJhA+IvB1yjZ8u
	o6IScnB3C8DV1Bm9uL47hrbjGBoSryq3qdAE5fMITEgbri01Tr1xYtUOaZa6GjKWSPjgWXRZGLv
	lvtEOQr7I8RYTWXFzPPzI1ufpCZXs4cx4P6lNbBwGA/q0SS0/cFGEH7vl2nRNf4QjdxnhG9GGxX
	gGUZwADNa0r0kk7jhxIu4e4vi+ArWxW9axAHQdP+NykpNZUsULNKgU=
X-Received: by 2002:a05:620a:3c11:b0:931:369:ff0a with SMTP id af79cd13be357-934a0a705b9mr2027822185a.35.1785858321563;
        Tue, 04 Aug 2026 08:45:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936418e2f7dsm103209485a.35.2026.08.04.08.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 08:45:21 -0700 (PDT)
Date: Tue, 4 Aug 2026 11:45:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>, 
	Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Fan Ni <nifan.cxl@gmail.com>, 
	Li Ming <ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>, Wonjae Lee <wj28.lee@samsung.com>, 
	Junhee Park <jh9934.park@samsung.com>, Heesoo Kim <habil.kim@samsung.com>, 
	Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 1/8] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <anIImeZdIa1lRbtc@gourry-fedora-PF4VCD3F>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-2-anisa.su@samsung.com>
 <anEIZOTDKsj15Nhp@aschofie-mobl2.lan>
 <20260804001245.079b16ae@jic23-huawei>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804001245.079b16ae@jic23-huawei>

On Tue, Aug 04, 2026 at 12:12:45AM +0100, Jonathan Cameron wrote:
> > 
> > When I view how this lands in the entirety of cxl_walk_cel() it seems
> > to needlessly be different from the pattern set by poison and security
> > handling in the same function and structures. Could this follow that
> > more closely?  Doing so would remove this 'tail' work here of checking
> > and setting the boolean.
> > 
> > This appended diff touches patch 2 where it has the first caller, but
> > pasting all here for simplicity - you'll apply per patch if you take it.
> > 
> > The bitmap lives in mds structure and it is already where the bool is now.
> > The only piece of the poison and security pattern not worth copying
> > yet is the wrapper struct cxl_poison_state and struct cxl_security_state
> > exist because each grew a mutex and other per-class state, and DCD has
> > none of that in this series (yet).
> Hi Alison,
> 
> This rang a bell as I remembered Ira did it this way originally -
> so I did some archaeology.
> 
> [PATCH v8 01/21] cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
> https://lore.kernel.org/all/67786b76a0c5_f58f294b1@dwillia2-xfh.jf.intel.com.notmuch/
> 
> Dan's point was that we need that infrastructure for poison and security
> because a subset is a realistic possibility. For DCD today it's all or
> nothing so why keep a bitmap around?
> 
> I agree there is merit in having all the command types handled the same
> but perhaps it is clearer to just have a bool.  Of course when someone
> adds another DCD command on the device side (which by definition will have
> to be optional) then we will need to revisit.
> 

Yeah, and it's not really binding ABI so no need for complexity until we
get there.  Honestly the feature bit check is essentially the same as
the bitmap check at this point, so seems find to push that
generalization off until we actually need it.

~Gregory
