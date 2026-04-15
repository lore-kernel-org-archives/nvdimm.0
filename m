Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5283E3D9A
	for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776273189; cv=pass; b=d8bqwWltS8Q5med8xmucSqwTQ7QozswGICh+hyinhGcZQSpxYuXRa6beR+kBZQK3jb8DY9+zP028BfWsIbb2PM9b8o3AEA8VHsPneaq5JeT33AUpSXEYwUVuiKdzsuTHqxT+bFkpcrC08GoiS7kAG71TgCU7NVgFAWbFlZe4j2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776273189; c=relaxed/simple;
	bh=wdhiL7zirIut6Om162VyHe/8jfVFe22PxHmav53dlqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AXU2BQCy5lpu9NzOk/0lVvoruU1EMQI69SPbM3Q8qQEam/1pUI+sIOUpPXl5br/OD4r+Bvna/8YjZQx5nirM10+VVHBYcXnHdLe0/6hrXb3WDANEEZYGCEMFcMV04/bfa/XY4uFmtuDdp5Ykqo8aS6xJJiTrJKuKGPm8mf4NapQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LgcUDo0l; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LgcUDo0l"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43cf7683a28so4793164f8f.2
        for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 10:13:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776273186; cv=none;
        d=google.com; s=arc-20240605;
        b=RDHH9pZ1vCcKVUJYDCU5zD9HYrdEIBs0nGlN05oqyuFdDTINsZ7LRnKSqLV/kcybAj
         YAt0KGVCIufPDigSr/79yYsbbBED5vkzQxP0rgmc+UmsN7cxOfa0PN1gs8FJ4cPufWmV
         K5aHHw6ZiIgiRU6xxbZJi21phUUwmVMdYz3bY4073vtTYmIgQy3fgjnYlt148rA9Q4gS
         eSC/e6LKr/HsjMNn4KJis1zONJZPKB8I19i56M00FAZktYbsOyrpaYb9200mF7frVtUw
         HgS2gkDBC4FQL4mWY/ll4t3CqavDujve569ktb1Z76v1aOAY5NBMZkFCN8jC7FOEo9fo
         6l+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lw/2t1b75/Yh/hGij9+OEBMIfvViI08SLiP+FJ468hQ=;
        fh=DW6C0J+tBuw+eazUU7LMB0NXPzWzA0rkgp7iH3HRD3g=;
        b=K8w13PBTItvMy0EXC3cK0SC1zq7DsAzbUe+hhAI/TVvIFmwlffhBkCdhuYhabJ7DgT
         tJupKv5WsQOIUcDoO1WKBopnDhcDGfnJ2TxTheF2+s7E6KvTfoiFqbHnPxaJ2NxRxZRk
         OVaAlFO/GvvSyz/7GBjkz4MyIG/oMC1OpmQ/eRj+M+NsLTI6wXbSq1BLs7S6C4MLTZrl
         ualhRa8YpLsX6KgTXXxFcsomvgtQaRGeI1A1zHjDOIlcKxZu0aL8/I3x/GClnNm32PiM
         hqgHeLOlwsVdGCCJU4lYh8bGWYB2pEm52Vm2MW+hyFeOxoGjxD4RWmxUWY3KuG2/iyod
         dNOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776273186; x=1776877986; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lw/2t1b75/Yh/hGij9+OEBMIfvViI08SLiP+FJ468hQ=;
        b=LgcUDo0lPUAVi0zPnjhjyNPbSOBXpTQAf5uGjSjyDg5rOwP4Yem7ilFGbpcH9fuWlg
         9cKEY090fMCh33ppHcgsND+tD0ZQi4VwMERCUAlm63YljQbatFqtfa/3dUDu2f7CWngK
         mX+QA8ZJfTlvaAzW0jox77tB902eZOef6TOnpuse9hvNkm7qIullfM/QarIfhQSlVYW4
         Bm9Qb1VfIqkv0HLVUuFkGrnil3tmc82hBR8RZ1qJPEzxCHH3mwuxRJmarZedMSAGtk4k
         bG3hcez6eIi4JV2L5RhaoSwpY0sSb87zNBvNfuwiHDQ/rYJbSqxK4Kjyd0Ro3Ruj1eTv
         SPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776273186; x=1776877986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lw/2t1b75/Yh/hGij9+OEBMIfvViI08SLiP+FJ468hQ=;
        b=dyfuEduQr5ad9qgzaIffYsZsNBtjXogfzaGeWhBuBm85HbQ+2VpzKsZLeAONJlLmFk
         BxAgPDq13MltznJJITfUR6Wbb1iz6KEdLnIz8gwR7xkNzZEvDE8Tqz+nspj4Y8hx0kkU
         sIpYOsEmP4gl/8cSXi1l+UrTirUyLHPBQjfojYFsLC3f3ms5rFgWqtzchs3+peJjc/M+
         RHQbma6qmtyQ8UbQ+yf7RDIpSjp1UZHuNX4LIa/WkvGwMtsP6uBuQt7SMr/4FL44rLOO
         hosOW/iNrfcWoTEaSdNjdB+BdhVYYB70iIaB64Nxm6kLuq6rg4vTVT302iEWm/3uZNmb
         abTg==
X-Forwarded-Encrypted: i=1; AFNElJ/YSdAhnU5mGS1glQAZ0eFSGaWYGKb/vo65ZAvD62aMmZWrEdnLqAD+WNrhsribPfqCPb4pShE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxMQ/PG6XpnFq/rM38Db/7L48JQnbrYr7tTR5ye1f73wJ9i5fxL
	tyS28MpUmtny/ar9nZnbsPHPviuyRFQgFVErCCe4tDUI2xWyCnYxcl4JmWaOQJ5gQN1COLjCxyk
	jQsghAzjUwstxrSeZl2hwDqKsBEYJ/4o=
X-Gm-Gg: AeBDiesE9gN+Ij+7mrCt55PUCg4vudwNarYcVFBeU1s7kbWJvg1TnAjHFDslzKacsqu
	yJq5QtkZzr0r1P3phgdUc9gMoiIerLpJjcIqi+6cnwndg7m3ce5QI6n2Qbur+LVh2GTu/qeXhUk
	qmD88zLVwGOZ22FECbraY09yNVMGabkRtnr/awWn6O0er5rT7WXAYdjN7QU422awvOETm/9qzGp
	fg9ZXdpmwVjGfK/HBIUwRN089gana8Hz+HY8vUCACeVBqqYilh1RkLPVxZlQ0DX3Hv6LCA85P7V
	5D3nnNe+Vy9KQJSt
X-Received: by 2002:a05:6000:612:b0:43e:a81d:c475 with SMTP id
 ffacd0b85a97d-43ea81dc4d7mr10552860f8f.6.1776273185949; Wed, 15 Apr 2026
 10:13:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F> <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <ad-UAMcALRubBcHk@gourry-fedora-PF4VCD3F> <CAJfpegsUVv0ziMSQiq9pKeXf6G-+LROPTW077hHMSmAirVCLQw@mail.gmail.com>
 <ad-qSB4oL5D3S-ht@casper.infradead.org> <ad-vnqRrUGs9n0N8@gourry-fedora-PF4VCD3F>
In-Reply-To: <ad-vnqRrUGs9n0N8@gourry-fedora-PF4VCD3F>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 15 Apr 2026 10:12:54 -0700
X-Gm-Features: AQROBzBkUIPEeKz-diD1-ugS7vjNoU9GOhppKCAHhyQ-ncyX3_eObS7SHF41aIs
Message-ID: <CAJnrk1Z+uNjn+BcmpciqPZhxYXEJ5Zgh=uNCxt17WTkdOubbog@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: Gregory Price <gourry@gourry.net>
Cc: Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, John Groves <John@groves.net>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>, 
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
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 8:32=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Wed, Apr 15, 2026 at 04:10:00PM +0100, Matthew Wilcox wrote:
> > On Wed, Apr 15, 2026 at 04:04:50PM +0200, Miklos Szeredi wrote:
> > > On Wed, 15 Apr 2026 at 15:35, Gregory Price <gourry@gourry.net> wrote=
:
> > >
> > > > This was my first reaction when I realized the BPF program would be
> > > > controlling iomap return value in the fault path.  Big ol' (!)  pop=
ped
> > > > up over my head.
> > >
> > > I'm wondering which part of this triggers the big (!).
> > >
> > > BPF program being run in the fault path?
> > >
> > > Or that the return value from the BPF function is used as iomap?
> > >
> > > Or something else?
> >
> > If a BPF program controls what memory address a fault now allows access
> > to, who validates that this is a memory address within the purview of
> > the BPF program, and not, say, the address of the kernel page tables?
> >
> > (I have done no looking to determine if this is already considered)
>
> From an initial look at the existing bpf ops structures, I do not see
> any other struct with a similar (obvious) pattern - so it's not clear to
> me such a concern has been exposed elsewhere or directly addressed.
>
> There is a verifier step for the BPF program that in theory would
> validate the range matches the DAX ranges, but i think that only
> validates the types are right and only on load - I think the BPF
> program itself would be the address validater, which is a strong no.
>
> BPF folks please correct me if i'm off base here.
>
> My initial take is that it's a real concern a "bug" in a BPF program
> could let userland map arbitrary memory into userland page tables, and
> such an extension would not be a quick fix to the FAMFS problem.

If you're concerned about arbitrary addresses in the bpf path, you
should be equally concerned about the FUSE_GET_FMAP path that's in
this series, because they're functionally identical. The kernel trusts
userspace-provided addresses in both cases. If that's acceptable for
this series then it's acceptable for bpf too. You can't reject bpf on
security grounds without also rejecting the current approach.

Please take a look at the famfs bpf program [1] and compare that to
the logic in patch 6 in this series [2]. In both cases, iomap->addr
gets set to the address that was earlier specified by the userspace
famfs server. In the non-bpf path, the userspace server passes this
address through a FUSE_GET_FMAP request. In the bpf path, the
userspace server passes this address by updating the bpf hashmap from
userspace. There is no functional difference. Also btw, this is one of
the cases that I was referring to about the bpf path being more
helpful - in the bpf path, we avoid having to add a FUSE_FMAP opcode
to fuse (which will be used by no other server) and famfs gets to skip
2 extra context-switches that the FUSE_FMAP path otherwise entails.

As I understand it, famfs is gated behind CAP_SYS_RAWIO, which is a
highly privileged capability. To use iomap bpf, this would also
require similar high privileges.

Thanks,
Joanne

[1] https://github.com/joannekoong/libfuse/blob/444fa27fa9fd2118a0dc3329331=
97faf9bbf25aa/example/famfs.bpf.c
[2] https://lore.kernel.org/linux-fsdevel/0100019d43e79794-0eadcf5e-b659-43=
f7-8fdc-dec9f4ccce14-000000@email.amazonses.com/

>
> ~Gregory
