Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CAB33936F
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 10:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784717232; cv=pass; b=ELWZqpCNoggYuhcbRSWia3alUq5rLbdVUT5DCBSu282YO5cBhmSuIhEdiNTCBSi70WaJ4JqtKq7vRsKWL28ua/+QK48LVVGxf4xWe52RncVw7m/zWwD9szKCEkMlYj+1sukFtq742nNW9bzNMIdSKbcEjHLZiuJZkTyQja9ZAYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784717232; c=relaxed/simple;
	bh=guAhZjJfEBfSY1xp7Mz+NJHa/zurYwT9YHjF7Gv7gyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vy/rIqBixWMMpN1FlYs0bTCezbghIYSDuoIjB0Q5iKgn5LgmcjLdU9Faj/CNG7R0NnuuNaaxqoeYGSPPeacGpvZCg2X58TyVnizGAARho78Z9lRMpyADwn2/UltZpVFVsE7S8+ysQqOSkilYTS7EG0oye9aVwAqrIas8mqBuQyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Yq1KBB1X; arc=pass smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Yq1KBB1X"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e5d6f35c1so1092401485a.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 03:47:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784717229; cv=none;
        d=google.com; s=arc-20260327;
        b=exAGv2DncNSjHUSgSDRJVv0FVMOeTtOWuw8SukbOyiV1kV/uphOwz9rOd2gPxkaYnt
         LE2MleUsiVePvac0xw3SOk6bx3qLBvb7K/I3PCKHQ3COzC6QaPhILC4vrTtkl7xCa7gC
         4T+s/D8O7yKnfTKAFbWp6Dk6gOz5BeVhOcnWx9wmYlujigfYMSqL3KXOLivRuZFv8XLX
         OTwjvxRRm8fEtKD2LSHd27+4eu0POMTk1eL0BPvUUAkQPAvz8DAOBQt7vxMWIehinFiv
         0W+kWdnWMkfFrCj4OCBBNX9pe+DtqBVKdMEseK85x2m8J7lFJM1/dlp94RvXr3eS8FCw
         hU3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7RG0U3kjlqqprl+YQXEPz8chW66ssUd6wO7da8Gt0so=;
        fh=XPxR4xbRNl3J52x0ZrISj5NfEPCyM00WU9D0gXfN31o=;
        b=DRBIyAA4jvFA4WboxppNqfZCCgr/a6ImRyhzQNmLkRx1UhZJi4qkdgPHa5+/+cT+yA
         2A7mWJJ3B/7bmVnM5SuQY9iPpiMKKSK+0LAJ40jGsdyhLmeiX2JhzgqY9OOKMGLjbZZc
         R3GqFo0adiiaAJ6k6mt4QkUAq4AAKJJVPkeiF00mQW4+Pk8hMljC0wLjWIUI5M/oqpWg
         Z2KCxEXi1EvXwvByGxFfFtYlMRWRM8m8WdBCvI93UcIMBxT/jPOJJug/yuv6Y3/AgkFd
         U8xfJZepUXXSi9iMG8Gx9EZRxEBaZlx6fTo8LwLsc1nI118SH8GyUL8fgQt10DXEqH0N
         0HCQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784717229; x=1785322029; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7RG0U3kjlqqprl+YQXEPz8chW66ssUd6wO7da8Gt0so=;
        b=Yq1KBB1XI63HMFu+0eFWKD9eu/2D2UZP2Xzx/8VUjWctI/75Q9D4m/5PLpQ6G/Qw2B
         56Cw2W09mjdmGuJPhYQbStb5oo0kT5JwCqgIE6PvoI1zO5SP3PSFWuOVzfvELFp+F7hv
         /NxVow4emrE8Yz2veij/NNPnymECagJ0fwims=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784717229; x=1785322029;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7RG0U3kjlqqprl+YQXEPz8chW66ssUd6wO7da8Gt0so=;
        b=s9VL283FKfX6uZLG+oo7yhDKqIwf5JH3yYcFhz4F1AnwlLej5PQ+yf5m324dNuaPy5
         I3O6QMSrTp0ZabqxY8KX8lGPvqURtyhEIG/Mh++xlL9Em5CZDeYtUs0byUQzY7/0V4hi
         93At6fKTAYC/tMKFjphsC3fRaG6VJ7bMTd7x8qIFRKnj+H9wjgBDY147nlmbuBlM+4We
         lw/IXKTmbN80vjpdWVgHQYBhNz8g4MydcjNLD/SAHJ8+/w+nflePxERN5ZPOzVD3qGtD
         gE1p66T8Y98imKQiPWrgehqOr0DkKAYm32qIQlUpwpXkdhetMzIZpYyuz4tKPBlkm/rd
         KmVw==
X-Forwarded-Encrypted: i=1; AHgh+RrKNNNckwCakGLGWAdg2MyTBTxLyT2n6+uwELLTN04devPvVyTEvuLiuCPOCGYszwsUQxSUH/w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyv0e1VKhnunHwPxtpz38/wn0Eo2PnpGUG5BIlutOIUDFUn+L2q
	PXaXU2s0l/at8oN/RJ6HmbYM+UW7KHDw5qjXNiu8ApWn4IZAK2J0mrmp7ZoYTiZpCwvbJVulwIe
	bxCApYOwST7OAyMsFnewJZS49Iq29SeWZbs6bPJ3/xg==
X-Gm-Gg: AR+sD12ZGzOgLwBZHoyzv2VJv8RlAjsO+8yhOcl3oswWPQIkuhVEBn1YUvTxa+oinDT
	WNZ1vJ4akxxWP9Di+ZRPEhV7dc/jT6OCBKPg98GF+jeWIlN6160nCTJafJ3G8RNtTS4vJW973Qx
	O+ar3nt4wcw8vuLfSfe7Zwf2bsIL+B5mQLAGmQnTLhDze0yNIoMjJswOWotA1sxTqvEKv6L3TNe
	aIav+oo56uEJPvuQAs6/TUdy+NXpLmtWRrNqoS4CnEDtWAd6fbH6sp6undLSmoHOJQLDxrA6okm
	Io9vcfr40Bd3fajetw==
X-Received: by 2002:a05:620a:4608:b0:92e:c118:18b9 with SMTP id
 af79cd13be357-930b43c45a4mr2167343785a.88.1784717229070; Wed, 22 Jul 2026
 03:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034358.68714-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
In-Reply-To: <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Jul 2026 12:46:57 +0200
X-Gm-Features: AUfX_mwdbQYshU7Eh86-5S9-gpZDCDD0EXLkbKHjoCISvWGty4DcFL-X4n78Y2Y
Message-ID: <CAJfpegt9PwHksYhsQZeCsW0eooXVVihyieTpeHMmC-+Pq8BWaw@mail.gmail.com>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
To: Amir Goldstein <amir73il@gmail.com>
Cc: John Groves <john@jagalactic.com>, John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Jul 2026 at 12:07, Amir Goldstein <amir73il@gmail.com> wrote:

> It's not about this ioctl, it's about infrastructure reuse.
> It's about the fact that there is NOTHING special about dax_devlist;
> and no reason not to manage it via backing_files_map.
>
> The reason you stated was that you want userspace to determine the
> daxdev_index/backing_id - fine, no problem - this is why I asked that
> you pass it the desired backing_id in the ioctl.
> In fact I think that all fuse backing_ids would be better assigned by user space
> so the extension of padding => backing_id is not unique to famfs.

Right, so I suggest to just reuse FUSE_DEV_IOC_BACKING_OPEN and add
two flags: one to enable user supplied backing ID and the other to
indicate that fd refers to DAX device.  The changes to do compared to
the current patchset are quite minimal.

> And the best part is that this request requires no changes to your userspace.
> You already bite the bullet and maintain the new/old uapi but changing the
> kernel implementation does not require this burden from you, so to be honest
> I really don't understand why you did not follow Miklos' suggestion.

Code reuse is also important, but I understand John's position to want
to separate famfs from existing codebase as much as possible.  And
because this is an implementation detail I don't want to make this a
show stopper.  We can easily fix it later.

> > - Lose the famfs interleaved extent format. I have complied with this request.
> >   It makes some things worse, but we'll discuss that later.
> >
>
> I am really not aware of a request to lose the interleaved extent format.
> How can this patch [2] from Miklos which reimplements this format as a generic
> uapi be mistaken for a request to lose this format?

Let's not care.  We can easily add this later if famfs (or any other
use case) decides to want this after all.

Making the initial patchset smaller is win in any case.

> Let me recap the former review requests as I understand them:
>
> 1. Use ioctl instead of GET_DAXDEV

This is done, just need to reuse the existing ioctl instead of add a
new one with the same semantics (okay not true because of the fixed
backing ID extension...)

> 2. Use backing files infra for daxdev table

Leave this later.

> 3. Use ioctl instead of GET_FMAP

Not sure we agreed to use an ioctl for extent mapping.   What we did
agree on was to use a generic interface that doesn't have anything
famfs specific in it.

John, can you please also look at review comments provided by Sashiko?

Thanks,
Miklos
