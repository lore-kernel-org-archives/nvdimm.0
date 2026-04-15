Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1894E3D6CB8
	for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 08:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776243441; cv=pass; b=YfFl2JmwL9El/pagNF6ALaTM/M1UbvYpg5ZyC4oc5vxmlllv7M64F0qEXlOAvkl3BqJZ8oxT35ijDajZB5t8cLi2K1sGgbBYskExmVjRrKQhmAw1qRZ6PiKueJf64mOB/VBIpt/a27JnGliTaO5BVKrYfKu2Lw1eU2LIRfeobME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776243441; c=relaxed/simple;
	bh=zZYtyxzFk/f/aBbXqwafBi1lDEMUVHJlRs1FsBDxTcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NHUzuBAL2kf7X2pZpweduiqGBRYVXEx8zHtbdLmlxpUKqzuSO5qohlB/Y2Be+VndtWdeD/LJg+i2R97FZncd6cfEQVi/tM971wYFpCoo2Tz1vPmThG+R8SJyIOZZXBqzI+kgiBLvPl92ABUpdEbj9x1wVlUF5ASe7CdvgmVW4pM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=obtSbVaM; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="obtSbVaM"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50d6144877aso67356561cf.3
        for <nvdimm@lists.linux.dev>; Wed, 15 Apr 2026 01:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776243438; cv=none;
        d=google.com; s=arc-20240605;
        b=WC2wxLkFO1Is/LJimuKGTvSl/a4omVQCr81Det8XzSwA5ujK/IQhbCivkoHeNNiTT7
         gmPqd2pylJ1eLv+kAgK2e9qIUMVUuTp2HWnXKmo+5Y1FHWLDuQwkzLNOy1hjV0T/mTKf
         b6bhEHKpYaWbri79bcW81m7p1v6YNfWVTLY/QywE3tAfpIuCvTx0z/kt8YZ3g1WWQCsK
         nWxlcVHdzfkMW1vbtq6Mu4Vn21XKXw9aII+CRta/t0XUcrF3gBhSqM6NtGgYRZNcaT5K
         SQEo54VATzQloyUmVbTP1KWTY8CUUjgeRW7hoCj9HDnp2TkoEsCd9ZcHanokG1GfKbZr
         cjVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1K50PrXkHzV3G2hBT2az5kpQZDgGSB8kie6wcwLv364=;
        fh=NRc6iTi0d84Iij3KG6KMm6Adyx4125vpr2p7UrFDw88=;
        b=EwGymR/QX7p6kTijaAzOdiGgiOyC96R7VPoQwGdGCS5nPh03uc39FoRK/MILjpnquz
         UTLsGmLr+Bcc59nY2LyP8Q/fhb4sdfGP/kKCC8jX3vC2gxCxlmPzqw+FcCj/J4s9780T
         78VkUxuctasPzLTq9zs9VTyj1vaAMv3E06U/DFKD7bs4f1Rgq/sXDop3yNa6kBMxNJtV
         rVWqCKbgviBQNaCLaesDuN5Amc3yXsNZ3rPFitap5Gvu+BkeX0oqbXyvI7+aPJJ0Icwz
         5/ID2aqf6SLgFI6t75ON+Nh6aTlY7AV4ktbtpVX38kM/0vHBk1CJg6BJeyIHWH4/v2tF
         JTug==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1776243438; x=1776848238; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1K50PrXkHzV3G2hBT2az5kpQZDgGSB8kie6wcwLv364=;
        b=obtSbVaMuAGR11AYmU0pYX3pDW76fomjVlXPtfefkqptqUdjuTbB7dEpJb0Lb5vpnA
         dkeBJEa0VuD8GH3SHFF7o15HbkkOQlvzQu/OuSctfmlqKdPqQqYI9K35km8+UroamEWX
         3akxhUfOixnJ6Aw0MYo7pI+vxLMKVlHmtyPsE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776243438; x=1776848238;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1K50PrXkHzV3G2hBT2az5kpQZDgGSB8kie6wcwLv364=;
        b=VGXXzvkr9bXg5HbpMAPF0d/gt/cGFhDGiKFgagBGTdgQchJbNh0UaaOTJsn5zOlelH
         lmpOCk2+FnjGeRMmhY2ZdWpNqchSPL1KEPRI1y56rTSdkdmmdtswlef+KwxZ2sNe4nNL
         zdueiwPMpJrZehzj0VngHGU2W38vPcdoXerJmNSWO47MGA+e/osSsa8j/NW8vE1TbziA
         AFyse6Ym3MB2kRWYCV4SF+B7igOtoA6cCCZPeVYFhzL9VHyhm/nIeM7A/e/i55OYgJz3
         y9bb4mVFe0IAL1p42dtaMGDmDYbmVCuhF7/m025AUw+fk7J7S88jgW0KyeMk3va72gsd
         ZS3g==
X-Forwarded-Encrypted: i=1; AFNElJ+ZVzrlO2uzFOZc0ieV2C8tTxIGCAE3mkvXPzf9Udr1BT7fhmkDLwiCuQYgz6HLPoBEAFfY610=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhrcYYstIznuuVh/RRuURxJu7ejZfRT2zjl3/uX+Cc+fJ16GL7
	pdnhFCSswClSXr/JtMZF4v7t6i630ehw78+/MEL6a4QH8RuQ0C0rDji/qMo6PY+MNXS1EPqXIke
	dGJ45qjCEw8OO9RLcGWEWRpJnpBWxERqnqtHduY2xNg==
X-Gm-Gg: AeBDieuLkqvx6x0HAjWFHWWgjkPLdX342/lwgB4zasDInB8+MTfCNEq4cC1NE+UB0gp
	JMNjY6iu2u50DArsAZM9rmWQuyKy+LAb0WoVVZJmVBIp48ZYfyfHR39UymeMVoUhg7WB6RC0PQs
	d7B7PeHfUxK6uz7xaEIfP4HVhFJ/P39NmW1SmdnUFTtzEe1AZj178rxxsuxKybpJS/fp2YaAy+n
	76G6n3fecjs1hjgj12rA44zyRyNaKK7oE8NVSRQTxLvDnZzdrele5Q3oKfvk/i/PKZXokIdUeFM
	MdYXxfhSkO2i9uY2j7AmIbg7+zcSvIJcv5vqmePbymWZid0=
X-Received: by 2002:a05:622a:2485:b0:50b:50bf:5bbe with SMTP id
 d75a77b69052e-50dd5adbf6fmr287758411cf.22.1776243437803; Wed, 15 Apr 2026
 01:57:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net> <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
 <adlBcwJjLOQDAR65@groves.net> <CAJnrk1a06zkUmXW5EFiUmgAoFauwtzsYvnotaPH0ifVtyh7iDQ@mail.gmail.com>
 <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net> <20260414185740.GA604658@frogsfrogsfrogs>
 <ad7MC5Em4l72nJ6u@groves.net> <20260415001558.GH604658@frogsfrogsfrogs>
In-Reply-To: <20260415001558.GH604658@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 15 Apr 2026 10:57:06 +0200
X-Gm-Features: AQROBzCRCfD21Ej4HAHDpxm8vYkUzgtnq-yub_KzWJ3NjPcdpwmvfwFukwnxXxw
Message-ID: <CAJfpegsEMQTwLP04L-EftdqNJrz2saBnK0Li6iZ9=5iiNa2arg@mail.gmail.com>
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <John@groves.net>, Joanne Koong <joannelkoong@gmail.com>, 
	Bernd Schubert <bernd@bsbernd.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Josef Bacik <josef@toxicpanda.com>, Bagas Sanjaya <bagasdotme@gmail.com>, 
	Chen Linxuan <chenlinxuan@uniontech.com>, James Morse <james.morse@arm.com>, 
	Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, djbw@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 Apr 2026 at 02:16, Darrick J. Wong <djwong@kernel.org> wrote:

> Oh believe me, I had much angrier things to say elsewhere in 2023-24
> about grueling slowass reviews.  That is, indirectly, why I'm now
> working on /this/ project. :(

I've been there too.  Which is not an excuse to be an unresponsive
maintainer, but that's unfortunately exactly what seems to have
happened.

On the positive side, I really appreciate the energy all of you put
into improving fuse.

Some of the reasons for the lack of progress:

- Fuse has grown, and I don't have a full understanding of it, even
some of the core.  Getting older doesn't help, I'm sure I would've
handled this better 20 years ago.  Currently working on some cleanups,
progress is slow, will post the next batch shortly.  Cleaning it up
helps in multiple ways: a) I get to know the code better, b) adding
new stuff becomes easier.

- The fuse-iomap change is HUGE.  By line count it's some 40% of
current fuse code.  By comparison, when fuse was merged it was
3.5kloc.  It doesn't mean I wouldn't like to have it.  On the
contrary, I think it's a very useful feature and would solve the long
time issue with having a way to mount untrusted fs images with
reasonable performance.

- There's no such problem with famfs, it's relatively small and self
contained and I'd consider it ready (barring any roadblocks on the DAX
side).  But the famfs specific mapping interface is something that I
never did like.  Joanne offered to fix this, and I totally agree with
her that we should not hurriedly add interfaces that will need to be
kept for ever (yes, sometimes even API's are deprecated and removed,
but it's much much more painful).

How can this situation be improved?

A dedicated co-maintainer would definitely help, not sure how it would
work out in the fuse case.  With overlayfs I think it works nicely (at
least that's my impression, not sure what Amir thinks ;)

My experience is that face to face discussions at LSFMM will also help
move things forward.

Hope this helps.

Thanks,
Miklos
