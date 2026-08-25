Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87C61531C8
	for <nvdimm@lists.linux.dev>; Tue, 25 Aug 2026 22:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787696120; cv=none; b=Laz+sf3y3pC6joLu+jeKzovu+7aVHGnI+qFPNDdD3dq7nXCN8wAlSWXHvZHyTmVIjMUY79x9a0sTL1qQIZGRoaaVj3gm1IaZL3J5Qh5owawIkBQrPfr1hZQcaKU7oRP0LhTFmbttMi3siEyL0AWWLEM58JMGNJOu1Z1/9K3877s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787696120; c=relaxed/simple;
	bh=ALvTtQS/ZvvUR9gxm8qmzRxg51/e/os61XAFTpQzc/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NJSnHaUwT52B/7viARsUF/jFCPmsMVB9se+NA6j6Bdto3v6n52G73UnV6jPxdng+DJWdUg4cJvZKdtglNOqPpJ4UezRrrtvD8J74WN6rP9Za5s096dtIVRTrOMvDmKycIDSR8DMBZFVB9d+zlRJ0zW2cGSCmDKZdgoaF/WaT+Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-97c79f2db08so122931241.0
        for <nvdimm@lists.linux.dev>; Tue, 25 Aug 2026 15:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787696117; x=1788300917;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ALvTtQS/ZvvUR9gxm8qmzRxg51/e/os61XAFTpQzc/U=;
        b=br5B2tZffUPeNeTMZ8BCxxVRDaxmoj2uRR4q8s/DJ63BwlEYsiQ+pY1X/Gx7rJDAfp
         1bCDnvbzu+vZwd2qUpK65boP5AAdhjWQlYOKKC2cTkOnEa6xs37Z/4hEv7GfgJyON2p0
         zrqgnqnnKrMoPaZimjcHMnVGoCyJKeeW4Y5vnKRsnPxbh++qhG0Vi7aDsTwvMKVmBpqE
         hBzwpz5MgQgnEZWTNVTO3wP+yXaEKXb19iraUHQBOm9rM/b2uuV6NXakVzY2TWmhTVa7
         PD3Z3UdIuUK3xQnveBLMU/qc48zhKtWAeJ3IrrChabrqCxusB2sWiJbctyh4iL+08wS+
         UPxg==
X-Forwarded-Encrypted: i=1; AHgh+RrNiejJzsmy9E1vXJROBVG/pw/iWUUmL+tMCilLED42MULgn9KJmG3GnPHfOfdUgceu20gntK8=@lists.linux.dev
X-Gm-Message-State: AFuF++niPqtsD70kanmgec7tXDf4fmxhGh/FIMH02erR3EXRdWPG5TsR
	CBHOOzwwZb9sHq2gMfoUt5N9hcrM7zSv2Numy79Ma3M4sFg6ZwTTO27UeYPPghNA
X-Gm-Gg: AR+sD13K1LjJHikd3d5d22FOx1bKYmjrQKSbwmT8d9aiGrZaTOB4YUwGxcAkMIX/Hqj
	xt5riNg9EbfJzgdvfW88yeGhP5u3V1VA485Gv7kT1t6cNpmPuo+zQtXMtCx/bVO1ruDu8P68XWa
	wE3Siez7Vi+HPMZup3iZpEFk37/+y2wy7aj5cpOKeVTMBbYrxDy4ZpFtSeoemUxURyHLlAuTdkw
	5Tv65lXbj0+VtbOZsMGK9H0dCyHDmVWLFlAO2nMKqLqJ4QforCKZgWpTXxS6B3S/ex79/ZaMQe2
	pokXwFdFKVSFetPX2EtEEM4s3FTMQpzh9CRDSGXVQQfA18RLjv8evSsJG5AmljT8jnH//NROIMq
	5HiaAGjx8yh6PswXLebtGKvBY9osTPXFUSQ/IBr/jyCVTKVja4nRjF/Gtjiag1ugvTDdJuiedqP
	0cyHTz+vE2/soL/6Fd5tjVHAA77Ve5sdjz76/WW7KycKZEEIfXimrgqXm/Ie7XeNBj8MtFC5sCi
	5i5VepYvXPd8I0Dw8XoTcmYUEsTXuCuTcPYVTZy3W8p29YZ/sxhb7EfPnPN3ODMf39ipTf5ZBtm
	a/KD0fz0qHWN+REbpQr+opwXgC7xAQZVQ5E=
X-Received: by 2002:a05:6102:441e:b0:780:811c:fd79 with SMTP id ada2fe7eead31-782c26f35e0mr938302137.13.1787696117360;
        Tue, 25 Aug 2026 15:15:17 -0700 (PDT)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97cbe108560sm187485241.7.2026.08.25.15.15.17
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 15:15:17 -0700 (PDT)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-97c8e173973so115816241.1
        for <nvdimm@lists.linux.dev>; Tue, 25 Aug 2026 15:15:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrxowj10s+pglS0n/Lrov5PZYIv3Z86tgRARiW4BLrRhOJnmtQyHJVVMCl0p2m/AipoKNb4X+g=@lists.linux.dev
X-Received: by 2002:a05:6830:7104:b0:7f1:ddf1:c731 with SMTP id
 46e09a7af769-7f4c5097628mr2648400a34.13.1787695731676; Tue, 25 Aug 2026
 15:08:51 -0700 (PDT)
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
 <CAJfpegsC-D0AJij3E=dbKzZCH0nijE7+rpPut-EnRd3r0uCMtg@mail.gmail.com>
 <20260822002111.GA6110@frogsfrogsfrogs> <20260825-hinab-kanarienvogel-mitschnitt-04a662533a24@brauner>
In-Reply-To: <20260825-hinab-kanarienvogel-mitschnitt-04a662533a24@brauner>
From: Neal Gompa <neal@gompa.dev>
Date: Tue, 25 Aug 2026 18:08:14 -0400
X-Gmail-Original-Message-ID: <CAEg-Je8d0kKH=kPiG7RDK4jGiTvECyOA_uFkZzbuvDpR+owJEA@mail.gmail.com>
X-Gm-Features: AcwNN1Ug6ZjMUQh0-6_7H39nZVAq6SWCLa31cOPu7pwraCiDoCVhUYh7Q1UxHT4
Message-ID: <CAEg-Je8d0kKH=kPiG7RDK4jGiTvECyOA_uFkZzbuvDpR+owJEA@mail.gmail.com>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, John Groves <john@jagalactic.com>, John Groves <John@groves.net>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
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
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 25, 2026 at 9:44=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> > > Without John's trust I'm not taking this on.
> >
> > Whatever path you and John decide on, I would very much like to see the
> > question of Which famfs driver do we merge? to be resolved for 7.4.
>
> While it is reasonable to place limits on how long a series is pushed
> out (I like to move with some speed myself.) we have two competing
> implementations and that will have to play out. We should not merge an
> fs just to finally merge _something_. The fact that this was more
> contentious than usual doesn't imply we need to merge a version, doesn't
> matter which one it is. That's a bad reason.
>

Well, after 12 iterations in this version alone (working on this for
three years) and forcing multiple side quests on John, I think it's
not very fair to him to keep stringing him along like this.

At this point, I find it hard to believe there's much more to discuss
about a not-a-filesystem that is relatively isolated from the rest of
us. I've been following this discussion and while I don't necessarily
grok everything, I understand it well enough to know that someone
should just shepherd it through with John and just work things out in
post. Honestly, the amount of metaphorical heartburn that must have
been generated by this is insane. If I had any say worth a damn, I'd
say let's just have Darrick work with John to close it out and get it
landed for 7.4.

Ultimately, the question of which famfs should be merged should be
decided by John and Darrick (presuming we just all let Darrick
shepherd this through). This has gone on way too long, I'm getting
echoes of the sched_ext mess... :/


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
