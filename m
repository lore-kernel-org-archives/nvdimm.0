Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D58157A49
	for <nvdimm@lists.linux.dev>; Tue,  9 Apr 2024 19:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712689225; cv=none; b=KLib3E3nZasGYhCojpsZQSEK04KQJjBr7LveMhdXVxfrSQA8Q4rTyHPZq0kr+keYm6q2JfA/3zNHdpHRAnVxNCWxP0lfXJAF3RoyLgYnKaWRORhTzpjMiInmLURHtwht22XZsNW9n/nHp3vjU71Es5dHDzabuQDIIdt5AHdeCE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712689225; c=relaxed/simple;
	bh=sKjDn1VUyv3xKTnhS+ZfRKeoso++HGRzElJEX6ZqbIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LyqIDwYdevjx6HxGidsL4ql+NjTOP2PjuIYaBJW/LdS1vKcofBBO0KX8zcv1hmPFj7bBbXsuC2McwSUtgZDVpDtS0fJdQBfMTR8M8yo67Cx3HMBgFg/X33Blu6RkmY+BFnkezGhGSmGJJMYZPVPnnfNSAQCMPVu+S6jRhEMeLh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=b9jQtxqa; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="b9jQtxqa"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-dcc71031680so5588051276.2
        for <nvdimm@lists.linux.dev>; Tue, 09 Apr 2024 12:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1712689217; x=1713294017; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5CBvcfp0rqG8/aCbqDf2QUOPCz/n3wHa5btTw1mm84E=;
        b=b9jQtxqaCZKZhgYk4tHJAJMHKxb/tckx7nXor6ac4bZoIZw9hRyptoFkVNYKMHngnv
         1kNgj0mNXi7Gux95TyF/S4L5PZGhkmEkgE1gqsbWFZ++qVjNNwc23CNSC+qSy+QRSqCZ
         RpVUPHm3GML0tNRf9S/UyYANJjxh/dXOnJYa3TRUHYU7w1/VEjgt/5MHSJFYG14r+W7U
         Dpr9AKY/EVjOgqSPNqbDdE82EYDbVH57vmT2aXOBVVP6HOiIFrA/Pf1cW13aFgMIy1I7
         D96p722E8ElYMaR5pEWrIyL4ZolvgAkDIT2bxRhHQdEpbg2PKes8EeyofU7SrXq2bQEM
         F3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712689217; x=1713294017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5CBvcfp0rqG8/aCbqDf2QUOPCz/n3wHa5btTw1mm84E=;
        b=Fn551QoWVqVNa1fWLoc28zvtgjf3o380QnBGkC6CeiA9r7/jc6ElLA9cDgWKZwdO6p
         zDNmwN8r9Knd4VgaHjcs9AJE8OcjYusRzvD9QTnTXSWeUJ138qDhIQg87tmbhyB0/kyf
         ROvqUZESzjJCWjLB+LLMb1l0L+3OoXQOn9f9CWU+DS31lzB7paFb4K0LVAJlWkmi3Scc
         rzziq13x2tvyyaBkpqwEkTGlC+5VHyJjJ9ln+zgg8exhp1ZDlwATzDq4P1ubifJM58s+
         RchUVfy/GisBrQiaepwDP97nBLmJLCRGfPnnL4ddT1Uj2NLdFrl7VP+ZOLhvn9Vs9mlH
         1QXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0vkDtYy5dJqja6Cn2clSuvvz0osrmLqoaPLY8gp9yz0/rsCEy2xEH/PdqtGQUcCrHr6DpYI83lis+6pi/WjPedztTAblJ
X-Gm-Message-State: AOJu0Yw6mOWix8LK1pDmwNkyMaZBGT7A0pdS2PX5qx66jHs3NRK84CmL
	X4HtbzFj22aQxTEs0dlXFmJrnAGP1f0uSt060UnDKzD3a+hx2oVsjIxGbLnQ2v0IOOe1BZlO3i4
	wX3xYJOs/H6w9FFSHEOC+/IJDvMwFrEkvMifXZg==
X-Google-Smtp-Source: AGHT+IGW6ppz/qE4BrLvmNCRDbTF9xfQE/vBrRFhezaSlxNTiNANoYpDGSEDGNZJ8OzMKjviuEREaTWu0J3o1ZesD1c=
X-Received: by 2002:a25:2748:0:b0:dcd:ba5a:8704 with SMTP id
 n69-20020a252748000000b00dcdba5a8704mr700084ybn.24.1712689217227; Tue, 09 Apr
 2024 12:00:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405000707.2670063-1-horenchuang@bytedance.com>
 <20240405000707.2670063-2-horenchuang@bytedance.com> <20240405145624.00000b31@Huawei.com>
In-Reply-To: <20240405145624.00000b31@Huawei.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Tue, 9 Apr 2024 12:00:06 -0700
Message-ID: <CAKPbEqrTvY4bsRjc=wBWpGtJM5_ZfH50-EX4Zq2O_ram9_0WbQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v11 1/2] memory tier: dax/kmem: introduce
 an abstract layer for finding, allocating, and putting memory types
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Gregory Price <gourry.memverge@gmail.com>, 
	aneesh.kumar@linux.ibm.com, mhocko@suse.com, tj@kernel.org, 
	john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	SeongJae Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"Ho-Ren (Jack) Chuang" <horenc@vt.edu>, "Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jonathan,

On Fri, Apr 5, 2024 at 6:56=E2=80=AFAM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Fri,  5 Apr 2024 00:07:05 +0000
> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:
>
> > Since different memory devices require finding, allocating, and putting
> > memory types, these common steps are abstracted in this patch,
> > enhancing the scalability and conciseness of the code.
> >
> > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> > Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawie.com>
>
Thank you for reviewing and for adding your "Reviewed-by"!
I was wondering if I need to send a v12 and manually add
this to the commit description, or if this is sufficient.

--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
