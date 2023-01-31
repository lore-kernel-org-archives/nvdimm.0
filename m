Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D79E33E7
	for <nvdimm@lists.linux.dev>; Tue, 31 Jan 2023 12:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675167466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xKlxpkUZRo2mPicdjcp1VlQPa8+dcAbG4ZeEJrymiQ=;
	b=ghaA13suJ5VyL5PV8ZsAYybxppdbXcKHQcM/jmkIde65st5Q64LzBHBQvk0LWzLodwabSk
	I04BBrKCATf3Yoaot5g2Mz5O9ld+IY0Ma20vztzRNMVZ1areXlCkUQvQdxX30Isb9RmHXJ
	Foowipo5QJMfRaUTU0CLvasLmvLNZ3M=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-320-6YbNKIgIMzK4JL-diakvvg-1; Tue, 31 Jan 2023 07:17:43 -0500
X-MC-Unique: 6YbNKIgIMzK4JL-diakvvg-1
Received: by mail-vs1-f71.google.com with SMTP id y19-20020a0561020c5300b003fe36c5c1d7so151042vss.18
        for <nvdimm@lists.linux.dev>; Tue, 31 Jan 2023 04:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0xKlxpkUZRo2mPicdjcp1VlQPa8+dcAbG4ZeEJrymiQ=;
        b=r5yB7R13+mPCV06nV/2MDNJvLbh5LQfZtQO4ZFXzabsMIsdaXv0Phai3H68pa51ukN
         HYRzzaT/WwBNHfc8MVg9D8ScdyHvJmdL1wNFdvEF6Wq7RXSk3Tw2f0zSDrc2xdyDqxEq
         FkQBOmVdFiyAmdVB0TfrpiI9JaJtsxHUkCETCbSYiQAhbFR3pPApqyRKHzllBsn+GPqN
         ZU0VY6qgstGEb9Cl3QfgXecKgwMobCmk/kas2rBKgi2F8V4B0TzgwiZI34BHQXvgFSCB
         Gph6exfAh95+q7nl9KNdA+e2mAmEixRk4M8XV1eLhZzhD4fT/DBBhEdebuDQZ7JynpO0
         KemA==
X-Gm-Message-State: AO0yUKW4H4VYq5gRgSplUp+3nU9b3Tc3C9Ympv+4vGJFP8NYjr4QE5jM
	mY4A/G4Vtv6QBoc0e1+M6KnjcUFjxZKpU4uzHpihbZ/hl6j9br/V0+8K6Rns6rwtl7JAEe40c5h
	E5aQXnx32chgL/49Z
X-Received: by 2002:a67:c119:0:b0:3ea:99cb:c3e with SMTP id d25-20020a67c119000000b003ea99cb0c3emr2996481vsj.2.1675167462886;
        Tue, 31 Jan 2023 04:17:42 -0800 (PST)
X-Google-Smtp-Source: AK7set/3cWf1zFQSzSaXyTvYZFmhtrofj2WcZS5Lru0KQCl9i0U0TOY96Lm9fQ3ijteXPFUn2WOINw==
X-Received: by 2002:a67:c119:0:b0:3ea:99cb:c3e with SMTP id d25-20020a67c119000000b003ea99cb0c3emr2996457vsj.2.1675167462612;
        Tue, 31 Jan 2023 04:17:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id 10-20020a370b0a000000b007203bbbbb31sm3325683qkl.47.2023.01.31.04.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 04:17:42 -0800 (PST)
Message-ID: <865b04949b69c3470ecb3fa5f93005e4c5a9e86e.camel@redhat.com>
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors
 (series 2)
From: Paolo Abeni <pabeni@redhat.com>
To: patchwork-bot+netdevbpf@kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
  tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, 
 cgroups@vger.kernel.org, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com,  mchehab@kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org,  dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com,  nvdimm@lists.linux.dev, vkoul@kernel.org,
 dmaengine@vger.kernel.org,  song@kernel.org, linux-raid@vger.kernel.org,
 gregkh@linuxfoundation.org,  linux-usb@vger.kernel.org, jdelvare@suse.com,
 linux@roeck-us.net,  linux-hwmon@vger.kernel.org, jiri@nvidia.com,
 davem@davemloft.net,  edumazet@google.com, kuba@kernel.org,
 netdev@vger.kernel.org, paulmck@kernel.org,  frederic@kernel.org,
 quic_neeraju@quicinc.com, josh@joshtriplett.org,  rcu@vger.kernel.org,
 jejb@linux.ibm.com, martin.petersen@oracle.com, 
 linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
Date: Tue, 31 Jan 2023 13:17:35 +0100
In-Reply-To: <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
	 <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-01-31 at 12:10 +0000, patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
>=20
> This patch was applied to netdev/net-next.git (master)
> by Paolo Abeni <pabeni@redhat.com>:
>=20
> On Sun, 29 Jan 2023 15:10:44 -0800 you wrote:
> > Maintainers of specific kernel subsystems are only Cc-ed on their
> > respective patches, not the entire series. [if all goes well]
> >=20
> > These patches are based on linux-next-20230127.
> >=20
> >=20
> >  [PATCH 1/9] Documentation: admin-guide: correct spelling
> >  [PATCH 2/9] Documentation: driver-api: correct spelling
> >  [PATCH 3/9] Documentation: hwmon: correct spelling
> >  [PATCH 4/9] Documentation: networking: correct spelling
> >  [PATCH 5/9] Documentation: RCU: correct spelling
> >  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
> >  [PATCH 7/9] Documentation: scsi: correct spelling
> >  [PATCH 8/9] Documentation: sparc: correct spelling
> >  [PATCH 9/9] Documentation: userspace-api: correct spelling
> >=20
> > [...]
>=20
> Here is the summary with links:
>   - [4/9] Documentation: networking: correct spelling
>     https://git.kernel.org/netdev/net-next/c/a266ef69b890
>=20
> You are awesome, thank you!

That is just a bot glitch. I actually applied only patch 4/9 to the
net-next tree. I hope this is not too much scarying/confusing.

Thanks,

Paolo

