Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF2E2DC767
	for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 23:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765409373; cv=none; b=TKa0N5PdcZeu2bmY5TVrvXvNgfLTGZviENqR659jLmlR+g8JWqf/Feksqsu4UyAuJeDYvtezXZUZ3xJuN+0R4PZt9hkO7UQ13VyMr1SDOXRTcKGifGHDTx4iD/ohFqW15bBcqRhRnF/u/QqDNeYHxu7UY8BHt2k+lEDFIGL6MPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765409373; c=relaxed/simple;
	bh=aqF0b14UzprPB5/tmIN8f6wh+mcFPv9LoXj+TufMJqA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e+k4vEnFDKPAb1vopGUKrUodHXEDV1MjrkhK1PTR8Kds9zO0CIGJ7xjhJMAFGuCOnQjhpIV6cUPEml73fOX7r8V4Gi0l1WfeK4daHd05h5olXW3kZSZQ/Zuvhpzyo+gHC+ErVhNj2zhthLwOP/5NSwODquVKxvdjbAJID/O7cGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bu4r8tm4; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bu4r8tm4"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so713915a12.0
        for <nvdimm@lists.linux.dev>; Wed, 10 Dec 2025 15:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765409368; x=1766014168; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nS0J0O1eWQ7LAl0fVJkBnyD56Bk+EqzYYTzRp7Kqlh0=;
        b=bu4r8tm41PRDylqCV62MUFQNdyxUcuALG0S1R9pDg7+1fmdoPWfadNNlti86ggPGuG
         kbuJSsOghiRuHpjqpYyoc7YnFnDd75K35WhWK6NHS+PoOvlq9bLrOdymnLRUtQXfVksW
         Z67BvJmKJW0z/uS36r7YM8RxWrgWMlGij1Ca1VKyImuKUVrHFcLtasAn0wSX22Kbe821
         t2uj3wsjVuwfQxyIAv4x5AdqqDhqfpb8aeut3Wtig1qWKdRjKXMSXhB0cUN9uvIJbhIk
         uoZ0BH0gB0FLDRiViANR9bdyA5rKpJzCnZEwxdiMU1IaHYUR582gFZCIsg06JgKFsWeB
         8dlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765409368; x=1766014168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nS0J0O1eWQ7LAl0fVJkBnyD56Bk+EqzYYTzRp7Kqlh0=;
        b=u1YwfPeJjzM3msb91lOKE2szslPCWLXkPTzCIMYUOFlK26IEASPPbzt9E3pfPoLNHa
         bO6zqjFrFQ1/tkeksruJm7SWsj0/NvWX8f0EmDLnRKre80bcgmPLGMzqWwm2madsAvZ4
         5PrM7nerh0Eu2DVN2NCUiwbkqePRu4EXf3+uCP0mlneYKvoaf2S1N2f8lrReZbUhjYl/
         dybtyEM4HE58DYcuJf1XeHfFoa7NYH2SYr6vbCNt7FcTkKqEDwd/ktV2dLUCGLPmSRMg
         YdWQ1PbyhZduYJzZsKbQCJ0RJBY3R+GzVmTKvpSIkj6yFnvIw9v4umJWzWI18tBU/CsE
         j4xQ==
X-Forwarded-Encrypted: i=1; AJvYcCViG5RmobODwIKXXOr51NLYlJhBp+p3VtJkVHf/zMqrRjUrWLeOFcTYRIcWw85J2Ra/J9K2YSk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5U0kYeD7aB2asBC0UFQgZM3CMqjpxs3WTacxingk6v5Y9DL6q
	R5SKTckWTC8gzHwJSL1/cyhLGm21w4Gd5NvTZkMdNVfDcKtKQXXkoeUi6dxVDR6hcseL/XNdshJ
	4WILY92I8q2a7ijkH+zPw1s53USxfcp4=
X-Gm-Gg: AY/fxX5iMzqrVeQL+nZ0c1mrOIwgntRzsSyMRpEnp+85CoYPRMG9toPPSkr7EI4YzzT
	OWI9U75ZUuiHASky7QPC3eh2Mvj+XkYGh3i3CyzTpMXneLcsaSiCzIS8ACuo/2+OKpEe+TUE1dc
	njzC4EnSJCjKGevg/acaY52NsZjsspxNlUYUhgb+baMavX6jvZgMR3jeYoarxfQUS8NFbiZ2Euy
	orRYgC0f3Llu04ywhUzrVjr1PYhHfh96OnAAGtNgXHjWmH0aRLU6LbGb1KGi9/hQpuuAOeOJA==
X-Google-Smtp-Source: AGHT+IFY2YnYNX5FT/khwOBS5XvuY7d1BKMmotDhd8P0VT8JClJq7mTFg7XBz3sw2vVuh5yIn5xaUUThFRZtLG6SNg8=
X-Received: by 2002:a05:6402:34c3:b0:649:5dbf:fb9c with SMTP id
 4fb4d7f45d1cf-6496db7a2aamr4068714a12.30.1765409367863; Wed, 10 Dec 2025
 15:29:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251112192936.2574429-1-gourry@gourry.net> <de15aca2-a27c-4a9b-b2bf-3f132990cd98@kernel.org>
 <aSSepu6NDqS8HHCa@gourry-fedora-PF4VCD3F>
In-Reply-To: <aSSepu6NDqS8HHCa@gourry-fedora-PF4VCD3F>
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 11 Dec 2025 00:29:15 +0100
X-Gm-Features: AQt7F2r_GFKD_JRPuqTk3RRhGxs_7478IUrJgqKiJlyTjHAwK1VTUcsA5pzKhMI
Message-ID: <CAOi6=wTCPDM4xDJyzB1SdU6ChDch27eyTUtTAmajRNFhOFUN=A@mail.gmail.com>
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org, kernel-team@meta.com, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	cgroups@vger.kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com, 
	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com, 
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, rientjes@google.com, 
	jackmanb@google.com, cl@gentwo.org, harry.yoo@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	zhengqi.arch@bytedance.com, yosry.ahmed@linux.dev, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, fabio.m.de.francesco@linux.intel.com, 
	rrichter@amd.com, ming.li@zohomail.com, usamaarif642@gmail.com, 
	brauner@kernel.org, oleg@redhat.com, namcao@linutronix.de, 
	escape@linux.alibaba.com, dongjoo.seo1@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just managed to go through the series and I think there are very good
ideas here. It seems to cover the isolation requirements that are
needed for the devices with inline compression.
As an RFC I can try to build something on top of it and test it more.

I hope we find the right abstractions for this to move forward.

On Tue, Nov 25, 2025 at 6:58=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Mon, Nov 24, 2025 at 10:19:37AM +0100, David Hildenbrand (Red Hat) wro=
te:
> > [...]
> >
>
> Apologies in advance for the wall of text, both of your questions really
> do cut to the core of the series.  The first (SPM nodes) is basically a
> plumbing problem I haven't had time to address pre-LPC, the second (GFP)
> is actually a design decision that is definitely up in the air.
>
> So consider this a dump of everything I wouldn't have had time to cover
> in the LPC session.
>
> > > 3) Addition of MHP_SPM_NODE flag to instruct memory_hotplug.c that th=
e
> > >     capacity being added should mark the node as an SPM Node.
> >
> > Sounds a bit like the wrong interface for configuring this. This smells=
 like
> > a per-node setting that should be configured before hotplugging any mem=
ory.
> >
>
> Assuming you're specifically talking about the MHP portion of this.
>
> I agree, and I think the plumbing ultimately goes through acpi and
> kernel configs.  This was my shortest path to demonstrate a functional
> prototype by LPC.
>
> I think the most likely option simply reserving additional NUMA nodes for
> hotpluggable regions based on a Kconfig setting.
>
> I think the real setup process should look like follows:
>
> 1. At __init time, Linux reserves additional SPM nodes based on some
>    configuration (build? runtime? etc)
>
>    Essentially create:  nodes[N_SPM]
>
> 2. At SPM setup time, a driver registers an "Abstract Type" with
>    mm/memory_tiers.c  which maps SPM->Type.
>
>    This gives the core some management callback infrastructure without
>    polluting the core with device specific nonsense.
>
>    This also gives the driver a change to define things like SLIT
>    distances for those nodes, which otherwise won't exist.
>
> 3. At hotplug time, memory-hotplug.c should only have to flip a bit
>    in `mt_sysram_nodes` if NID is not in nodes[N_SPM].  That logic
>    is still there to ensure the base filtering works as intended.
>
>
> I haven't quite figured out how to plumb out nodes[N_SPM] as described
> above, but I did figure out how to demonstrate roughly the same effect
> through memory-hotplug.c - hopefully that much is clear.
>
> The problem with the above plan, is whether that "Makes sense" according
> to ACPI specs and friends.
>
> This operates in "Ambiguity Land", which is uncomfortable.
What you describe in a high level above makes sense. And while I agree
that ACPI seems like a good layer for this, it could take a while for
things to converge. At the same time different vendors might do things
differently (unsurprisingly I guess...). For example, it would not be
an absurd idea that the "specialness" of the device (e.g. compression)
appears as a vendor specific capability in CXL. So, it would make
sense to allow specific device drivers to set the respective node as
SPM (as I understood you suggest above, right?)

Finally, going back to the isolation, I'm curious to see if this
covers GPU use cases as Alistair brought up or HBMs in general. Maybe
there could be synergies with the HBM related talk in the device MC?

Best,
/Yiannis
