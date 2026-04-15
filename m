Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF1437F72E
	for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 14:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261906; cv=pass; b=IZSJ9XlbKzRzEwTu5xxn47zVKa6B7rvnS465eRnGV6u6y/RoHo8ebsD0jK3Jbix2+Yowa+47ggWRHSQo7oht95r206qq/vPbQ/re0MNSEPTE/Ts2HdjGCWNiVL4sRpXhvZryErU87PyUc8VnjeiamRTE6cZdPLFjPo7Vjo+Ev/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261906; c=relaxed/simple;
	bh=OuxoKfF1eIFYHXEVVTIuTwEbgi2RzLTEr5xC4F2+szE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RKrOn7Qm+iLSp0bZaTdFZNLbpe64aNuDwyu/277H3q6F7oivufcuq648NIRp9PLMLQUIiMeP7Nwa+wSXmviSIz6nMCdZKe572CNxc87Sv/elDI23PtXyoMOEMpGzCHVjs/ksgwonlD9B+mIW/yISpM2Y3SrvyFcOED+r33tAwdA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=F1q9QJ52; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="F1q9QJ52"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506a7bbe9d0so54049451cf.0
        for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 07:05:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776261904; cv=none;
        d=google.com; s=arc-20240605;
        b=R6yog4M5tlxZRSmYQcL617Eon2F7CeXy7X3YokbK7wkPoBgCnGGt7eSIEFVA5aWDNn
         1W3Sbr62y+cgUhwRNDR8B/J3igPzXgRKhCvg+Gfu2WDV/aPEtq5oeo8C6GvQBeKtaA/0
         Zbc8sNsBQnqUIwIPPg4l+t/Dxb4UV5IVmAuFjWtPiyrI75ameQPiP4Tmz79TrqhDPPEn
         g3KhTYUCntvZJZ92gWEFBcPQ4791GylXMskjWw28tYK8nsvN9XOLH0fNAKtm5inTcSv0
         GyOEQM2W733LGH1YUU00OMu3ydoC9WDvGbnZ928UepNGZ/hEJ3oDIeaRQC8mUXYgvyXO
         FA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Nn6fMxeMg8FDWayAItzG5oIgCrdJaKGk/78HcE957DA=;
        fh=RXv/DQqhyWcL73Wzlqbcb3fKgJdZtzQlW53ZI9rkQNE=;
        b=hcTr7o72ojbGeHD6z0ozFNBFKtuFAuww3Lnz4DKaCBvpvkaPuGck5tFKyq7nxVIBu9
         RhfLL0rQskkSahG/7hybN4n3jr93l+MoB7XdJ7yprP5vrfaZBulMX2U4AkVUbpsgyH1Z
         xuPxxhs3qTxQzZ7MoPAMzxWuPlQCusdIS719H1hNoFDaOBkxDCK9+BXpa36UPVt6FIrD
         fefPu5H0dlYXKVykkzXlKefcjcNKZ7vu6qfAQOEweR2VR2r9VA5wIf5mAqyeQIe73GBM
         ffb5mFC57PV4JL12n1cfPz2KI30uYexSyY+qMgcXzKS1nHZrRe1fZ65n5tYX5SvMTV5w
         gtgA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1776261904; x=1776866704; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nn6fMxeMg8FDWayAItzG5oIgCrdJaKGk/78HcE957DA=;
        b=F1q9QJ52M8MHCtrS2JTMn2AMG+RyKMXsEgdoRHisXg+elDCT0L0dJAuPlD89xLEd+x
         CUFocconOkTa9csniIBF1DtGq+Zgey/qbPXc1evci67Yw6mL3gggMrHIifA1FdhW0svm
         8Rehv27wIzvG6LVci86y3swMsNVrpS6i4KSRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776261904; x=1776866704;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nn6fMxeMg8FDWayAItzG5oIgCrdJaKGk/78HcE957DA=;
        b=r2Fejo1aOvN4adqJAVC0xbcPdTZ62iqF+fUs0g80i/fxs1R68EH5+YQM9hJ9uZhjlI
         lL/rrHDm8TgJg0R5tqQMCDPkpqruwa0EZDArl4Li5SsedSUhTZMGhsD2XvCL9mQPfKM3
         +VWR+au38HS8dEjRvlUBj+oDMp0zrNlw3Sl0pOTJUvkgg8hCgWsTo67uH/Oe1Am32ZYX
         lv2NR7TTuUW3YJE2C/aXk1bm/RfadggiWGVeflS+cIP4/MY5MXQPVQaTg3kipCd3D7pA
         746qbMOcEYuRzAyJSMztsaNHMVKOCdU9VwpwFfX5lMgIB1Zn0iTN8DgJPECmd/lns5t3
         88QA==
X-Forwarded-Encrypted: i=1; AFNElJ/1+Kv0O8AEkKhxUqB0JuOk+OFlsMn8xhlboSQA42fhxmMGlfLbjerP7M7Qi/MhGE4guyuVU2w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwE85qZgoZf0OZhEeecIZY5DP3Clt0iO5TCAWeIazoF8PH5nw4+
	CfQeUVJznTvSQfXnbfuqE4ly4TNlfppMNjPfR677C3IABqK7N2pkjbCVyNvQq+z3RvIsg1W6J8Q
	r9DnKc40o5NBAJrSGAReuyr4GqcrLfOutCi7PY8vdRQ==
X-Gm-Gg: AeBDietAMrdFFliT9GQb6qRlZNuh3eUHAjXT2SeBOkgyyfkRgOvF35rP9zdHJQDCM2+
	TkWD9wDxwl6k40fMCW7PDr94pmEAAy9jwfmE3a8tlELpFjghbNZnpDhgYeelua/r0bD1X38qMgG
	OEvmITbXYfLTpJb+VwAZLO8ZokTIsAu6gXsBYrSHnT9YTD95rvXR2UFimwlf68KV0ciq0WHxx0S
	kR2ALuuNAk+015w1oazWPZmIvNiQ5xH0uSpEkZ8Lavbu3NqAKPvk26yTBSm6AnixGmtZAE/yRyt
	OTJAHSxBfX7gpScxD8oCj0hBmkhPfomq4mvj
X-Received: by 2002:ac8:57d4:0:b0:50b:567a:e915 with SMTP id
 d75a77b69052e-50dd5c10ad8mr322793641cf.64.1776261903663; Wed, 15 Apr 2026
 07:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net> <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F> <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <ad-UAMcALRubBcHk@gourry-fedora-PF4VCD3F>
In-Reply-To: <ad-UAMcALRubBcHk@gourry-fedora-PF4VCD3F>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 15 Apr 2026 16:04:50 +0200
X-Gm-Features: AQROBzArU4_0DWulqMJjaZBbvqSvSBgOVsWveoXthohq7f36XvJ72ClRliOsfUQ
Message-ID: <CAJfpegsUVv0ziMSQiq9pKeXf6G-+LROPTW077hHMSmAirVCLQw@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, John Groves <John@groves.net>, 
	Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bernd@bsbernd.com>, 
	John Groves <john@jagalactic.com>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, "venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 Apr 2026 at 15:35, Gregory Price <gourry@gourry.net> wrote:

> This was my first reaction when I realized the BPF program would be
> controlling iomap return value in the fault path.  Big ol' (!)  popped
> up over my head.

I'm wondering which part of this triggers the big (!).

BPF program being run in the fault path?

Or that the return value from the BPF function is used as iomap?

Or something else?

Thanks,
Miklos
