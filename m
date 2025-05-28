Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FFD28B407
	for <nvdimm@lists.linux.dev>; Wed, 28 May 2025 14:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748444066; cv=none; b=CycS9Q6/vJPjK+azawHBAs/51hcz6bodntz7oSj+eMVV9qNqz5ku476hum7jfJpkjz4yp7slCqOdQHEPeFSXHFMHjqXkElqh4l25pCWq3mxuvWnSLR2a+rPmVjDsOrtNIglyVea7mbEyb3ph3aMDqXSetTZDGJqhMfwWIuz3IUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748444066; c=relaxed/simple;
	bh=OLQTEynOWLTW2J82I3GAFi2XTNtVPRqouMqsxTdKyrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgotu/cK7uDi1SfUFSc5sXr3mwLj6fHj5BQimE2DgUoKxnrQT9DovQSh2o/FNbALfJDCnTXnM1YyFQ2bhf2/BWxLFZgo/ctgCVPJ5mGJBDeZgR5BFwN19E4t2KLlS7bdnPX7hUF8GRggZv8ITMmsvzQ42Jc0gjbQbe85nUqWNuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b=vJXLhrI4; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b="vJXLhrI4"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4769b16d4fbso21482321cf.2
        for <nvdimm@lists.linux.dev>; Wed, 28 May 2025 07:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1748444063; x=1749048863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLQTEynOWLTW2J82I3GAFi2XTNtVPRqouMqsxTdKyrA=;
        b=vJXLhrI4HKDtq4DcXGWrXx+ulDG7pMHid8DFPiuJSIBnxHXyZDNF8z7FqDO44niW13
         8Xzdl7Pf8+Jr60wG4sik2m4qbjh074aAXAry9yV3wfu8SwAFCLRDVGKkSrcczIobh8BR
         IXGuLRjef9gGlS1QwPFejiJNpGch5bocrbVyopaSP2kfnF7Ne/tcm4nW9DajxsZ84EMl
         zcH6Yps1q4ElxwLtlPTDLu9ngZ5bA+phQpdbvQXoj68Shiz7Z4VZW7GTcCwz8GuvrXAm
         spg9jaKA4MF9lZivJW3dCZ5w+T9NBB4QGrbiUvt4PUuoGp8YfUlVtUOt1E/SaKzTriba
         x9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748444063; x=1749048863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OLQTEynOWLTW2J82I3GAFi2XTNtVPRqouMqsxTdKyrA=;
        b=pktLtEDoHqWfr/c8KVy3pyz9yXn95VL1DzVG2BRtrlBhEJBrm1eFDZYnMDxncK6Vuw
         yXlkXgDqBGEmqAt/jP5Qce88cuQwN0HPRdc4LbPby7JOCQmChDAD9a3Hmp3jD8E8Q7xs
         xW7iSeXJstYANnkOCws3QdYs40SRWiNo+2CkXRChObI++p5g0ROAzApqLSA2VFOtCu/I
         nNszHcGTAPpODLNyvm0nxWxd7QYB4fdgc3f6WPEBlZ7axqy/up9SYUPCP56CdDKxdmqF
         d98AQspZurhSg5sKU/WDv0Y/2TBPEBmXMe7v+EpcTijUGLrreNYJzL77Zr4BWljvEmvM
         kXAA==
X-Forwarded-Encrypted: i=1; AJvYcCVac5m4salK/zzU7dbFgrfQuKSdDTvuR8N8brINO7fJrspRqer/MqLgwEE2faoWvLS/Y3VXW6o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxsg1DHD9zWyq2lQ3Hb6+1N5mkJ9QrukFDrj8xlVLJOY5oBCF0+
	LWY4nqwRFq1dNnH70RuOm0L0tFcH+9ePo4lBGtSpIyzXeFd/JMmzBFupVEKpX+fSJJTFZtLf3mn
	Riw7WXiwRzSnExfYr8mIPbXiNLUJLsjCYS4/NS2iG2w==
X-Gm-Gg: ASbGncvhjnkdJsgJ9tpfR1mKO3nmt7B+3j9K5om14oCeBIep9g7fvpf02iHDnyuY9W5
	QTK3qd05DXNU0morXRS4Ca+6pnr0oWDrLbjC/gssCOU6H84xbz4y6bCsqY/wWEFOoakXbaes+f0
	BE3mpeJ/2qBnHHzdXI+VAc+1tb7nzS6XxSAxSCptG2
X-Google-Smtp-Source: AGHT+IEipULtuHP8NgolkdOGZlrY+wJ98orFgKSxJBZZ4sZQQx6BiL/ks+Oa5sABai8uN1rdHCGApBJm6ZxwNh0g7ck=
X-Received: by 2002:a05:622a:1b10:b0:472:28d:62b0 with SMTP id
 d75a77b69052e-49f47a0ddb2mr278495661cf.41.1748444063296; Wed, 28 May 2025
 07:54:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250417142525.78088-1-mclapinski@google.com> <6805a8382627f_18b6012946a@iweiny-mobl.notmuch>
 <CA+CK2bD8t+s7gFGDCdqA8ZaoS3exM-_9N01mYY3OB4ryBGSCEQ@mail.gmail.com> <aDW9YRpTmI66gK_G@kernel.org>
In-Reply-To: <aDW9YRpTmI66gK_G@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 28 May 2025 10:53:45 -0400
X-Gm-Features: AX0GCFs1Qbwk6LJZXavFVBcYckw_C3R55DAtQO0SII537wDbPP_9ie9BDYZJ2Uo
Message-ID: <CA+CK2bAUfXQ_CSKs4MaaNNcgPx6MRjE6Jk85tKGYUOQBG8PFNg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
To: Mike Rapoport <rppt@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>, Michal Clapinski <mclapinski@google.com>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 9:26=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Apr 21, 2025 at 10:55:25AM -0400, Pasha Tatashin wrote:
> > On Sun, Apr 20, 2025 at 10:06=E2=80=AFPM Ira Weiny <ira.weiny@intel.com=
> wrote:
> > >
> > > Michal Clapinski wrote:
> > > > Currently, the user has to specify each memory region to be used wi=
th
> > > > nvdimm via the memmap parameter. Due to the character limit of the
> > > > command line, this makes it impossible to have a lot of pmem device=
s.
> > > > This new parameter solves this issue by allowing users to divide
> > > > one e820 entry into many nvdimm regions.
> > > >
> > > > This change is needed for the hypervisor live update. VMs' memory w=
ill
> > > > be backed by those emulated pmem devices. To support various VM sha=
pes
> > > > I want to create devdax devices at 1GB granularity similar to huget=
lb.
> > >
> > > Why is it not sufficient to create a region out of a single memmap ra=
nge
> > > and create multiple 1G dax devices within that single range?
> >
> > This method implies using the ndctl tool to create regions and convert
> > them to dax devices from userspace. This does not work for our use
> > case. We must have these 1 GB regions available during boot because we
> > do not want to lose memory for a devdax label. I.e., if fsdax is
> > created during boot (i.e. default pmem format), it does not have a
> > label. However, if it is created from userspace, we create a label
> > with partition properties, UUID, etc. Here, we need to use kernel
>
> Doesn't ndctl refuse to alter namespaces on "legacy" (i.e. memmap=3D)
> regions?

Hi Mike

ndctl works with legacy namespaces just fine. We can convert them to
devdax/fsdax/raw pmem, create remove label, etc.

Pasha

>
> > parameters to specify the properties of the pmem devices during boot
> > so they can persist across reboots without losing any memory to
> > labels.
> >
> > Pasha
>
> --
> Sincerely yours,
> Mike.
