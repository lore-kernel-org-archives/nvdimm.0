Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A04C39A04C
	for <nvdimm@lists.linux.dev>; Mon, 24 Aug 2026 07:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787557276; cv=pass; b=ZY38cvrmO7GVH6yer3wt1J/B/umd5SoVqc5ctI2z7qpsD5nfgCAI1rHy223LSbMKINNCJJgoqR9200Xui5a9oqNNQ9IUsgX/k+D7aUHWbLU9wvitTHp0hWhutXm6rTxdJT0zyC2JQibm8ozZ/QJPFK1JnY1BdWaw9qnEsi4A3Ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787557276; c=relaxed/simple;
	bh=mdsvrY0ISPRS0P8l6Q2ATVhO2qJcd3GXtM94ZK/661M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KV9ksOM0lugrjFGsTlM+od8QGKiUEc+ZbfrMQs1GPeDVxJX4SUhEx3mnfq7gnTjV3xfQ0pZsBKThFxxUQylA2qqKli8vviVVftU6ph3k7gRRqm54vEUEQXSIe9OxujPSj3PAF/6AHpE4+D7d3ig/inDcwZAXkxNdwDg+2EejeQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=qngrBtqL; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="qngrBtqL"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52b6543169fso21479821cf.2
        for <nvdimm@lists.linux.dev>; Mon, 24 Aug 2026 00:41:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787557272; cv=none;
        d=google.com; s=arc-20260327;
        b=cXxNHTXCdjwAPVZ+6kAtB+luP8bKIJc0Zq06mBZ0A0iHhc9iE67dw7Qe2sWzzyk+AQ
         UIY6vIydsox5zGrHyn3vlaqiXTiJnpvcUMx30PuHZcov1wSIWh/oZ+kCrq4XFixL5NNO
         XG5dKyvXlZCTD5KhIjXejMARPxUfnx+CYfIEThsqgzr2/hBKfYlmoDTS4NaRClPzZSP9
         zewBcgdXlE4Lmpo96thnfoeItOxDGMkQv1UIN/AWalwLLE//XD4U4C0my8jbfvOiFucc
         ljVqFHSQa/b/e+trJtCJaIp+O+Vg9qEBwcxFVz22BxV/SonPGVUw0MyOb6zsseL/tJJq
         R5fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Klk3k/9iOZSzHajoiDP/ePmCKQpQct/Ey07OIgVaiL8=;
        fh=RsPLzqE8R2RH2LflsxHfcVpWIKZH0yDjCyoKrrBx3hk=;
        b=hfTWtDsWsy2pDQzKIq+t2KIIuAcuh3SmjgQEoln8h970roDT44PYfvpv+77qAfEHK5
         /fZkHmK09GuD6thaIpH7jxpZf0FJsKfw9sZAbOc2pzATEouIYjf/k3s7gfgVheFBG1Uz
         /oj5UnI6lEfkN3Xypsxo87H8hK9qgpim1CASNfs9S9Iqg3zQO3+CtZhz2fiTsymgvd4P
         ftDLf+flp2b4Mo4qj7xBkW4AJKgS8oZZLzfJtc5t8Dt0flBql2uzSZDpFcvX/MeXfxXZ
         Hn5hF9AEcvvI9ctCujycGY38JcLu6MV0z7vEqsEDQX42xR4fdpHdt92+MZq3oDHDue90
         8Vuw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787557272; x=1788162072; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Klk3k/9iOZSzHajoiDP/ePmCKQpQct/Ey07OIgVaiL8=;
        b=qngrBtqLyfKVeKCmJLlqZG65oS2ctUz9DMBBykKdwQ8Zw4378TivKRy5CO7Ck91P96
         V7OAqF5W5vDE4iU6j5ff9kfrN180WZq0X5ECQHtxTBAK/ng/Ac1hmg2aNAapC4O6TM3M
         xCSVHwtlgrgz+EuWpEgCT/g2yor3/lg2N56aA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787557272; x=1788162072;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Klk3k/9iOZSzHajoiDP/ePmCKQpQct/Ey07OIgVaiL8=;
        b=Rkv6Kv7lvAzyhBRNqOWbwKH7V2LJl8yetW4agXuvEW7y+BaC5FcZsK6HZIdftohs+P
         wHP7iE0qZnT3EWmCD5bSwVUOlpbv2V5wfSyiWHSyWuUw3Da7mo3pRCycmlszc+HRrnng
         LxqGWQyaKAbfeQuyG34zbUuE/WWntXR+a9GWtagoV5MQC5zjALU8PMr2RHFqjShxK0ds
         84Q67RAyirll60i8GrJ2hJHGhz2p/dP9YO+WbIJQkBJBOPqL5G7YXzP39MKheVdgj868
         +zhXkF3Og8N14AjFLNoabVp+rt7uFCNIAgVVWFUcIqkQ7I/3MS9tj/zbxpwmmNhFCUpR
         GxQw==
X-Forwarded-Encrypted: i=1; AHgh+RrVZHPyvF3Lg7MvbRr4slYdGZTcd5CQy3sU91oGuq1olt91UnfJt7cXy1fuTYDXZPkoBm9HAck=@lists.linux.dev
X-Gm-Message-State: AFuF++nA83GE43EnhnJIVlP+TPKQgcEj+DprJVrSf0sN7QPYqyHYvILU
	MKNYfVN9r2WX4XCQsF2FOnZSzxdG5LMFyzADZ3Y92WiUh06V1SDTiWDnz34zb+TTkqaLy0fUKi9
	7zAzAaPKuA6tA1pxqJxg8Yh+k2wgoKfrDR2u2qYOviw==
X-Gm-Gg: AR+sD11C5CDM7I9IRGXAwB6WDDHnuueh9m2qSM5Q7HvzdMW4PNq3ogS8xC/NMWk5sKG
	PAnVnJk6WMxVuLVjREhKY0nRLBFfhLW86tXWyETItQtkB/N9g7PIwxw0oC3YfNVghkXUzN0MIzu
	m7WpxfNVQc6YZ+aw4FjLAjgB1Q295+nFQuyFrf/2qc0ffRBfr+wjWLKX6gEJDaNXs+eTzE2dp9W
	DH0PZWdRxErJmq0cZec0U8Ikub95jipW/fqzbRKqeDuz7W036xYIUbRyAm+iuMAq2l3YA7MFUYQ
	BEsfG92uMjIOGLgeoGsbqkgCev6lILsJHau1Hv+/OhPvihrjCyOjHy5BR2/gWA+SulX0gOV5mq6
	t9ZU=
X-Received: by 2002:ac8:5815:0:b0:51c:1117:c6a with SMTP id
 d75a77b69052e-52df56f0b73mr226396731cf.4.1787557272431; Mon, 24 Aug 2026
 00:41:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com> <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs> <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
 <20260811-baugebiet-hofiert-fanden-3354f4a5e820@brauner> <ab642f3a-e377-4292-b2ff-bc970f5384e8@kernel.org>
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com> <ea56c85b-d564-4451-b704-58448a07bfa6@app.fastmail.com>
In-Reply-To: <ea56c85b-d564-4451-b704-58448a07bfa6@app.fastmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Aug 2026 09:41:00 +0200
X-Gm-Features: AcwNN1XWfONgBRIlU-yXy6CPly98fZpO_MCf0GW5eGggOdo-Gs861y_E4L66dCQ
Message-ID: <CAJfpeguuL8He4dKC0+CQU3c=Ss9nDEH=9VckB5mqxOr01X2q4Q@mail.gmail.com>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
To: John Groves <john@groves.net>
Cc: David Hildenbrand <david@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	"John Groves (jgroves)" <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <jic23@kernel.org>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ira Weiny <iweiny@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Haren Myneni <haren@linux.ibm.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Jiri Slaby <jirislaby@kernel.org>, 
	Ethan Nelson-Moore <enelsonmoore@gmail.com>, Gabriel Whigham <gabewhigham@gmail.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Sat, 22 Aug 2026 at 23:55, John Groves <john@groves.net> wrote:

> Famfs does work in fuse, but some of the asks are things that I don't see
> how I can agree to. I think Miklos and I should discuss those 1:1, to figure
> out if there is a way forward.
>
> I think the virtual backing-dev thing is a non-starter,

The virtual backing-dev is an abstraction.

Is it sufficient for you if I promise that this is going to do the
same thing as the standalone famfs at the same performance level?

>  and I think that the famfs
> portion of the fuse ABI basically can't live without extents that are
> (daxdev, offset, length).

Sigh.  My proposal was (backing-id, offset, length).  Again this is an
abstraction.  A backing ID can be a daxdev, a striped logical device
or it can be a block dev or even a plain file.

> Also, I'm curious: if you don't know of a use case for the striping code outside
> of famfs, why ask famfs to completely rewrite that?  (and I agree, other
> than the eventual remote possibility of competing 'famfs-ng' fuse servers,
> I don't see much likelihood that this piece will be shared.)

Because the striping feature fits much better into a virtual device
API than the extent mapping API.  This is how striping has worked in
linux for the last 30 years.

> Miklos, I trust that you are a good faith actor, although you seem to be
> spread pretty thin. Can you commit to a series of 1:1 conversations with
> me to try to work through the disconnects?

Fine, let's find a time.

Thanks,
Miklos
