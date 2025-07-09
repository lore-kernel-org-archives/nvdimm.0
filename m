Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9EE1E9B28
	for <nvdimm@lists.linux.dev>; Wed,  9 Jul 2025 03:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752031626; cv=none; b=GL3QCfC9wJTc7CD48I2tlB/niaYMV6LwyN1efBtT9ZAI/qAe7rMFISdQ4iS9AUkBMx52n0Qggjq7TaElQsimpeuKBgNETpETgDsm6x1m5Fjy+xDax9u1AO0wHZg7TJJoiPAxnPRrRsMOVvPWekqBABj3FlPjZ141t15eq72Jew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752031626; c=relaxed/simple;
	bh=zw/fej0GkXW5A++Ge3FEYjbMmbv+hTBMbj5gw+U4//w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LP3gaKTmvYfdE/KqK+cVWJe3cJiq9xeeDO+/zybhAHfVdHsOGmQ6vJ8dbxoKoXuF291LRiTcbJyaQCcNNH8kiLUhg0yQFSKOEUD7rWDnETiTSACtXMeJVQ7Eunql+r0vz1ObavW1u+zV8GI9CxsyARrwqNUv8VeCd4PViGf9xxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=bK2gZAyc; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="bK2gZAyc"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4a98208fa69so5371111cf.1
        for <nvdimm@lists.linux.dev>; Tue, 08 Jul 2025 20:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1752031624; x=1752636424; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zw/fej0GkXW5A++Ge3FEYjbMmbv+hTBMbj5gw+U4//w=;
        b=bK2gZAycApIm4mQTzQe8ZFaIIAca/gDH2ZVmg7JvLcWM90JT11NFXgFGwhW77tukOv
         AQTJiWsQYS2m0IRFNTHjhhzaN6OIoU32y4PFvbqBD3D+1KDijbSqHEsqR9vpm3shUnKN
         2RLSK/kuhc61WUaLBfM1wUbpYeFr5Jo1gCW0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752031624; x=1752636424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zw/fej0GkXW5A++Ge3FEYjbMmbv+hTBMbj5gw+U4//w=;
        b=ZL0NsI8goCc+AHuFbYYUz5fwcR47+LgPg52u/yy6tdp2A0LUB/iD7GmSfr5Q2sNZmZ
         0EEjHgDrO4QiA6FIcqsCxCC8WCzzJy9XPwDqrS1cVDCf0mE/t/jhq/MOxBqjJgfsx1/h
         4pKljp3lLuT7z70KVtMtCUk2SL9PxhyFr+RZvj2NBaBjA+Za+eWaHSY7vooNdWd4t68p
         KS86pSs6DZKtsGa2+zTh86wwxpkD6lyjQv9NzDfaGFkUukvvUnDkUvVlcKiqiMamvW8E
         LkjYroKdNDN7QcV59pnjeRUCKc6Asxg9j7l9Q8WaUKUndXJMEiBnjuIZmbi6VuZMLZMx
         LrCA==
X-Forwarded-Encrypted: i=1; AJvYcCVEISNvEfKoXpdg6sHresZ9ozGHVG6l5CVgKMlecaB7VL2+ENV7hjVFKTF52IOaYf8bhVdgKAc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzGGUMUPBnHZfKIbjstqcR5IxrCAzk6j95BXOMRB6W0m+6b1sB
	3P/gQo5lbINirOgAdc/VP2n4eEkrhNJ1//cvHp1ze+s4G9KBhFUHXGZU90sPjvuO5tAE13x+n+h
	Ejc6PI6rO/AtFS6V0B1K48D9sNWLrvepZ5x3Gg+Blvg==
X-Gm-Gg: ASbGncvMspLN83Oj/Jnne2AUy6tdZ+02pjBEooyB0LCscAoH7C1A3RQ0gRRRU+3U4vg
	cNOWhTPQbKIul4Wh94DRkv+tkjhTbJR0schCrh/eiOCmP14rGmgveS/vyTRUqSoqIU2GnFn2lmv
	qFrqhaXvJ9lkh11Kyy7IKbej7auZFWftdw8SzLD+xT4Bq9
X-Google-Smtp-Source: AGHT+IEbfuPtiB8SJ8mM3IIy/0e+1oWhx4UxNRjIANMV3UTN0UVNRrT4FqNMCrH6Q0szGd55OwaVpm23wRX15i4H4tQ=
X-Received: by 2002:ac8:6f19:0:b0:4a9:8b58:6300 with SMTP id
 d75a77b69052e-4a9ce5bbb43mr86267521cf.16.1752031623903; Tue, 08 Jul 2025
 20:27:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <os4kk3dq6pyntqgcm4kmzb2tvzpywooim2qi5esvsyvn5mjkmt@zpzxxbzuw3lq>
In-Reply-To: <os4kk3dq6pyntqgcm4kmzb2tvzpywooim2qi5esvsyvn5mjkmt@zpzxxbzuw3lq>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 9 Jul 2025 05:26:53 +0200
X-Gm-Features: Ac12FXw6hgYHynMi-MN39oWlDifPLmPqesU1MFQWRlURFDaTLnL4XYV-SQPgaEw
Message-ID: <CAJfpeguOAZ0np25+pv2P-AHPOepMn+ycQeMwiqnPs4e0kmWwuQ@mail.gmail.com>
Subject: Re: [RFC V2 00/18] famfs: port into fuse
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Jul 2025 at 20:56, John Groves <John@groves.net> wrote:
>
> DERP: I did it again; Miklos' email is wrong in this series.

linux-fsdevel also lands in my inbox, so I don't even notice.

I won't get to review this until August, sorry about that.

Thanks,
Miklos
