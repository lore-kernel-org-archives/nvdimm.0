Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BA642047A
	for <nvdimm@lists.linux.dev>; Tue, 11 Aug 2026 09:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786438805; cv=pass; b=RgYnxfqXXiCKsc8mBDvZ9fggWy9feMQCXBWdCGGctM8KvLQ0V1W5Jg2uqusdWvtUulIW33Nc2ELUpAmam4K5eVZqniBK7xdkwRyOznZd3iDz0Al9ttEY4kCgJQT3IkrhVPb+LN/wczW1YjXmUk/c6NCC6NT0oDdLvLKaKyAyNFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786438805; c=relaxed/simple;
	bh=QAVJs6W1FBqjbAOF/0emhNqG9jbCkXvsyG1EUwOkxnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aaB5+zbyqsklKGnj5ksl67Xx3pE2kHPzB7wiQ6mOAQdT86NsQifzJUhRRDmFiveZqPtRRWYRpw9UEoYeOCwx3ttFVmPGIuuLHazBlqsydrVEADFtGUSlExp87UfCtkAp2cVa4noEbBm+FQBr4UrElnsRhBWhI0vrPP38sEhXS0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=PlcPOvba; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PlcPOvba"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-934944f2d22so30506185a.0
        for <nvdimm@lists.linux.dev>; Tue, 11 Aug 2026 02:00:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786438802; cv=none;
        d=google.com; s=arc-20260327;
        b=RKRTiVM3w2FZT/VkHC9LOP98jJp/S/FMOWRFeZqiVrdJ4TMRjxjJO7p3i1r6BnDepU
         Sle15O+PEXliZqunzhqn14gUQZrqPQik93a7J0D7N2ctbVltBUs2Etgix2etLr5+hcZD
         ZlotWeGjVHb8Civa3bqIMoSSyAGuBw8z9HDlIrWiBWcAbvaBAYccFXkjbT3t0yMJ10x/
         AyOUW6d1WpXZlCkVGLeX1y3GGx32PUQ3wIhKNFGPIuf4NGRLgD+2fh5A+dX6BffDkM37
         bZboYczfbWFay7VUyNQ6R0i6vcuEvzjSTg8BPBWf7ImTv6jxs8natDh3tm2P9xM7ywez
         AURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=03hUfqpAtMk8895qbCCQElojWBhsj8Ov0HHep5mUb5Q=;
        fh=OB8pLegOxJyEkRV4VRyIELaiuLfsqK0jResoLlyfdOU=;
        b=fnc7lyPXIqczmXAqAlVxxB4LEtm0e/K8IEHmbibSLxeJmHri0syG4ErERnRx5/UwQs
         J9oKLiNZvO/sV95T9M0kOXkZBD25rFt53DrHd1Gzzg4DUP4xdQlGKZV1eh7K7fmKfNqm
         GLnEXcih5ro0Rg9U8M4gdvzlyXr4hVBo6oMQwpYH0qU29OQ98ZDK9wpItqN8y9bsSpM9
         KNce5UP3uBJVXPYZV0iPk5jIESKm7Fs/4KszBXUBFqA876H0/OrX+y2AlQSiKh/iycqT
         NxJVjwGLHVmSQMyxxa0GRcLmLiVyHKEGkmhZjcMcMljDAIkJZ7fPkTIGNleFKCYQ2Hj0
         alLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1786438802; x=1787043602; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=03hUfqpAtMk8895qbCCQElojWBhsj8Ov0HHep5mUb5Q=;
        b=PlcPOvbaXTEeT7hTdfgIs87oQkW5phE+M08k9qJa7fXs/ahc4ky0kjf8kum2+vuhrc
         4fLlg+do0lRbW8mVFBwcQE7SlO9V9NOChhpHfLjT2EbjQgv3rhiSfZiN/5yIEL/hgeah
         Y322zeOUwhXKs3AFswmOcvzDeKINP0QeKfgsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786438802; x=1787043602;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=03hUfqpAtMk8895qbCCQElojWBhsj8Ov0HHep5mUb5Q=;
        b=QYh/UuLuoV9/cCqC9JFGKdjlcbRmw6iKdQxX3OGHB4IfEFRlx57Ytbr+Itm5PybXIJ
         X+sZPDMMFcqgHoyIK8TfXwqBWD1ls4T4uBnhoQXfS2al0/F/ZG6zLYiXd37UaEIEX4fA
         HhI9vBaVLzwViyz7yssaBJDj01/c3QOU09mW19M59hQPAMVhJUoOhwQipiPn3lpnTEf6
         X5gACqUShhKGRs0A+rZDPZjqzE5aKD3MpOBA5dW6WQwp52GyElvKbN+27Y+roNUTDLqm
         sJjv65FTnjeDp9ac8uxmOwMnxAPMQHcVAFVaqB7ARFtOo854qsA6XUmOZzPKlVyKTcta
         9ctQ==
X-Forwarded-Encrypted: i=1; AHgh+RpS14hKCasa1tX7KC+dQibvtdYhnJDDDHmAai4Vs5FkPH4u7i4KGhmEyamvk7DxgBwsnEGHlNI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7V0pMvqL2bGhCQpczbVMaEbgRQCbH9vav0bvc48717Dmq+UoE
	XhFjsuapPmw+evW3NgsgAocBPtu+hNXfyMZoG1jiC9SmTB+VnbRv3VfAWoPokwL8F1aRJm/Q0T8
	njw/sg/EMkt8iZfhyd8aa7V860gAfTz1MgVmqWoCFig==
X-Gm-Gg: AR+sD11ZdzqBdC1wBwjBO06tttCBcGLhMDCXs/JJno/rs1kVmTe7/w08X572IV/1eba
	nH72EDQH4sthGNq3o+9uoRqAUvA9CY69cUUZp6MLdnt/SLFFykVvyYDcrXm3ciqomp+pvbtdBUl
	czn/5Cipx5xFv1xdCXC62YYBDFZOlZdUdfW5wadBDZIQmQzxVV0EqHO4JrBf8/3AHS/mvvdbnaj
	ibRerjhknsHSpIZ5hsc2jfrU3D1bqjLuUQtsVBnpFPj1QKRA78bqs71fA47jqaXWc1mpGuHwvoQ
	iGsNykr/6LMXpkC5PYLscBb2AxD20j7OVj00zc/wHWAx7M3b+dVpCKyR2c0s6TTclS9+YyWirKu
	42RzaD5UmNQ==
X-Received: by 2002:a05:620a:26a9:b0:930:9774:868e with SMTP id
 af79cd13be357-936a8e70eb3mr130606285a.7.1786438801859; Tue, 11 Aug 2026
 02:00:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0100019fc572ca94-ec363dd7-3a77-484b-b4b7-f2503a0931a6-000000@email.amazonses.com>
 <20260803022828.75776-1-john@jagalactic.com> <0100019fc5739e5d-bc002300-eede-4c40-9ca8-a277b754496e-000000@email.amazonses.com>
 <20260806043712.GB3560084@frogsfrogsfrogs>
In-Reply-To: <20260806043712.GB3560084@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Aug 2026 10:59:50 +0200
X-Gm-Features: AUfX_mzPBN-WtEK90PQcEbgkE1jczoRAdcaPSoPUxrlnLvA164kB5DWNAs636Zo
Message-ID: <CAJfpegtW4bFn=oNfTipCxhiExaqSXnhXeBd6Uq15FpepqCJaPQ@mail.gmail.com>
Subject: Re: [PATCH V12 02/12] famfs: Module operations, fs_context, and mount
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <john@jagalactic.com>, John Groves <John@groves.net>, Dan Williams <djbw@kernel.org>, 
	Bernd Schubert <bschubert@ddn.com>, Alison Schofield <alison.schofield@intel.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, Jake Edge <jake@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
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

On Thu, 6 Aug 2026 at 06:37, Darrick J. Wong <djwong@kernel.org> wrote:

> IOWs, let's fix the remaining wobbles (if any) and just merge this
> already.  No more side quests through gigantic refactorings of fusex,
> that's too much to ask after you already redesigned and reimplemented
> the whole thing already.

Without any intention to change the direction, let me just state some facts:

 - it was never suggested that famfs depend on the fusex work in any way

 - the plan to add famfs mappings to fuse was laid out two and a half
years ago in reply to the very first rfc posting and has basically
remained unchanged since then:

https://lore.kernel.org/all/CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com/

I understand how that seemingly simple API addition was overwhelming
for John, and I should have been more proactive in helping with the
implementation.  That's entirely my fault.

On the other hand John could have been more trusting that the plan will work.

But that's behind us now, let's move on...

Thanks,
Miklos
