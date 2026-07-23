Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450D5381B01
	for <nvdimm@lists.linux.dev>; Thu, 23 Jul 2026 06:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789754; cv=pass; b=GfO9h1ntGV2MbnU0gpo2r2C1iUtiXPZeJJAs1mGsoTT+5rg3VE8S3QTArZu6dtO4x0r5TCINZKQL1ObrSVWsoK3D87O/cMOpPHzN+Y78MaIyCJMUlCEJUMde7+ZAPNvuh4gyyQkk6AexuMFa9I8ZBg7qLTr9/eqvpC/7AQBFC+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789754; c=relaxed/simple;
	bh=7xavlvPgaj2aZOYRfaOcUw2KPrv2zI3pLKx85cjIG00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=exs1vR7fLrGKny8V+D8QLLtDaLagfIiP+XyeWjBu4eLPNketY8E1qeEKtxccoHDlUhaqbMYvCthN9TVjtSl/ZULQmLKAVKMHrSW41RTC4dhExqsXsBJMITiV69+/v/4hR5XGEGbbKkWxwpS7dcXNdbSjjar4oqG0QMAupCwy2v0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=PoIyG7OY; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PoIyG7OY"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51e4ba1cfb4so2438451cf.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 23:55:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784789751; cv=none;
        d=google.com; s=arc-20260327;
        b=MUNISKlFwmSe8UsRKie7grUhuYeAx+kr5iy4hy2q3fUu8gURSUXV06rJzlfx+8uGMA
         Jz5lroQ5VuWCzU80w5szENLWwfNHWYA1DmOCRUeZvcZ7+uAIt8tbk996XijW4Us6+ltO
         KRrVO+5G8FAlTi0l/oSuEZV7rA6Dgc4Tav39+xZjXJ7iQyXlnAeS7Zuk2gRJVO3Kz4sh
         rtBQOpCBec4aj405PJ2INb47vrraPKCa7BCEEC+MyC5d9s9O/TFNPlA09vRpC+r+j4cU
         ShtWCF3YYnG/HaWiNefW4bnz/l5IGJ4SwlEEO1lMrBZlvnvN0TSa4OcgcF45bRJNVe37
         Kerg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/L/US/G+XEKajQPS4lkAeBu5twJB/EgGo9GV13H6UZU=;
        fh=8GlK5sLV+dVJcxwx/U1NwS81V2sxnkeZzFxLuqpVrio=;
        b=EeBfWrFmKUS0MB5owQO2o1uD0dmAtDPRls+rCyMSF5L3qDr0D86asxlaB0CxCcCqFw
         to/fEI/KMs+1I081AZf+dh/82tvgCvaHu4fPZK0oZ49LIJjztFC4Tf8qe9yG+Ngszsih
         tpZxCCCStfRxNECRtMwnoRZbEtTPtAWUFpjSFet+rnNwRsr+pDiVyLK6Tm/iSys3TvHy
         +VBLm0P9t8XvpZzV1Epine9vXO2ja8/UwMzdd3R07tf7RfxE8Hko8RHTg+yYT76RxrrD
         FCgJlNNjU03DVvphFX2R8biOkS2TCcUIE1mKWk0FhxU3LyWuuHMiY/KXnd0wZ4uNMtuz
         ujgQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784789751; x=1785394551; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/L/US/G+XEKajQPS4lkAeBu5twJB/EgGo9GV13H6UZU=;
        b=PoIyG7OYhZce/eZZ+2XDuwTc2RsaKgK+8HJpt+tjp18Q11dRa1hb+stO+AX4FGMnc3
         v4JnLdnKhpKgnwiEepO4d0vSZ60v1ITKUdrZbwdgrKJzMRQQEOwYMVK5FH/hcry7T0JA
         IIbWS6nU3INYmDJZGrQxr8Y8/pP6eewCO3z3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784789751; x=1785394551;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/L/US/G+XEKajQPS4lkAeBu5twJB/EgGo9GV13H6UZU=;
        b=kHyHbUinyWKpF0dkCaU7mQHd3719d7XunVU5AJ4L4zgvwHRehaUOMNbEahXQseZvsZ
         0464rIn9jrine3D8IwTlWOS4/gh1kf7aWoTcsv1YzVG/CnX92DzKKUyMwilhYuQwbrBL
         237iS0t7cX4SMpuFgTbUK3+4YTTe4W1vvOoK7cdI/nWXlF0WiohJwLPjlSdTANBJqOkK
         meYv7jgpvlgU/DI/A5S3KEZSGPXT8JUpZy1XlaReP4vlFmj9qmsSmsBMU6SdnxZZMtq4
         Mej/q3THCwSkem0XtbhGoB1y5rw2oaY+dU2KD7ISAZiFC2Kf9d3HPAkvLA9lSvu6pV9a
         m17w==
X-Forwarded-Encrypted: i=1; AHgh+Ro00PHQXzyyb8jGDRsHZK4poOCfGKwXYXuj3jYddVLgsb8vJhL7tKZMXuiOkbqGeSUqy7TkTz8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh+2ZfzFokBg88C6DMasv152BTXC5RqpJNEQIBnfgDNuZGSyZI
	IqsUPzhAftqVe24YNMAxrAJgBfOV5e1tmeTPnS/QieM7Kxdl68DWE01/K+4B3ooBrRMjleBRRU9
	wPBmR1SQC3uqdTP6XRsraXv2/RPnGXH4r+B6rIbcMBw==
X-Gm-Gg: AR+sD10VO6Wht08AWYGfA+Fj56FvA1RJ6Cibs8G+MjFdcc5Gu7dZlD7EJOD3D85fYe2
	6iO+ob5OB8H1Bd++uNZU67B+gBROyuuWiecVuJZxUEuzO7M8+4QI/hW9INQSry+oB4jT3utN7BS
	2zFruD0Gtxwb4Z8nwVwAXOiR8Py71UyZDQwf/D8Xe2rWxXMj4Z+lPmwcpe3+Ohiim/cjL3Ywhny
	n/Q5uB7C2KZaKx4v/e4QWqEP4kQ6SPVWL4JEMdb5xfjwqA7gqlUdbjrNZaQLuLBW19AXbsvfgku
	5HRAXEhRePLOmW4Z7/OYv7900RcgjM/djOJnHNY=
X-Received: by 2002:a05:622a:2cd:b0:51c:7b12:5ff4 with SMTP id
 d75a77b69052e-5283dfea04bmr15949681cf.80.1784789750870; Wed, 22 Jul 2026
 23:55:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720034358.68714-1-john@jagalactic.com> <0100019f7d9fbe81-6cb16662-2522-47ea-a152-fab0ee3d9b35-000000@email.amazonses.com>
 <CAOQ4uxiEzP2e=cRw-AiGxtSv6WMSA5yR3cmgrF97s7ggU6wzqg@mail.gmail.com>
 <CAJfpegt9PwHksYhsQZeCsW0eooXVVihyieTpeHMmC-+Pq8BWaw@mail.gmail.com> <amFMUtTB4SmHdYZx@groves.net>
In-Reply-To: <amFMUtTB4SmHdYZx@groves.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 Jul 2026 08:55:39 +0200
X-Gm-Features: AUfX_mwm61XvzbEAWjZX7-oCx0aIcunUf-H5-PKtYcEgLU4ucKjhPy9XCcc8KUQ
Message-ID: <CAJfpegs81UPgqh3XsvAAE6PfDOiPcMceLZD7p9SRR+HaVZbgTg@mail.gmail.com>
Subject: Re: [PATCH V11 0/9] famfs: port into fuse
To: John Groves <John@groves.net>
Cc: Amir Goldstein <amir73il@gmail.com>, John Groves <john@jagalactic.com>, 
	Dan Williams <djbw@kernel.org>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
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

On Thu, 23 Jul 2026 at 02:32, John Groves <John@groves.net> wrote:

> I will make this high-level comment: After reading Amir's initial reply, I
> concluded that the requested changes push famfs past the breaking point,
> and therefore the only way to keep famfs suitable for its intended usage is
> to pivot back to standalone. I do think that may be best all-around for fuse,
> famfs and Linux. I don't see any way famfs makes fuse better - it's a very
> specialized pattern that doesn't fit in a passthrough-filesystem or
> block-filesystem shaped hole. And I don't think it can comply with the
> "nothing famfs-specific in GET_FMAP" objective.

I can say with confidence that there is nothing famfs specific in
GET_FMAP that is actually being used.  There are some unused and
redundant fields in your struct that can be removed now, and we can
leave space for future extension in the extent format.  Adding code
for unused features makes little to no sense but can add significant
burden.  Allowing extensibility instead should be a much better
choice.

As Joanne mentioned, adding extent mapping to fuse would be a
generically useful feature.  It's been on my mental todo list for
10-15 years.  Sure, we can do that without famfs, so...

> If famfs is standalone, it can only ever affect customers who use it, and it
> cannot be used as a general purpose file system. When famfs is in fuse, it's
> mashed up with code for hundreds or thousands of other use cases. That's not
> a win from a risk management standpoint, and it doesn't make famfs better -
> certainly not in any way that would mitigate adding a lot of state /
> complexity / baggage to famfs.

The risk of standalone is abandonment.  That's a call for the VFS
maintainers, I'm not going to stand in the way.

Thanks,
Miklos
