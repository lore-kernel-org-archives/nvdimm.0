Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A9C4DDB56
	for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791970850; cv=pass; b=oLhyXOz6+4D3tsi4nu6/6nwMq61rN7VOa2SpHsKvRVbWty2/34qYyqBBvNjJynpAEWAgXYgj/WQms8tBE0rdh2+lXFzvQyucpS/108wlmGryIiP+dnBsPtU5iEKHPnwDX9VEXT0atU7L+Ols2JfWV55Tu7DCY43PH/MPetZqeX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791970850; c=relaxed/simple;
	bh=9/reRJ/j1yO6b6rjpq4fLoYRPvxibxm3mLaZMWghcMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B3xfK9c4X5CvTv0u/gcsGU2PHbMZKfMzbvtKkMR0c5dB84A2Xk2aR1It5Dg3uggC+VIqBR7JvbFsVTu8JG9VSOoynJjlgaIbLnwdRYDvlLCAnU5TLpvB/SzePyajlFrNUyn+2jCDXkBHw5VUkGgz+zBc2U/vqMCz/hfMk1U9EWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=cDjmFgQl; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="cDjmFgQl"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-53394bffe0fso9015321cf.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Oct 2026 02:40:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791970847; cv=none;
        d=google.com; s=arc-20260327;
        b=WtQjrQGhcyNFAl8fvbTRNa0sJQ+JHzL1HjHi0/uv3uQX/SrFV1ymQan79WanS1vLgH
         x3dRtqI9LlFS3m/0+T8d6EGLhQCtjLaoMYs0623YJHLGZvplVq+auf3C8GcwIM0ld+bG
         Z1l159jzvcaxSQtjXmCV9DKtQXkhlqmm0Js71DPrRoSFwC8j51UjLshwR0qG57zMso9W
         m/pzwPUHJZyCwCy9XJAjR7Ctc2yKeBRNURm9tmlDsifTjPUC+12pzfUKc0Q4H5O2ySBc
         bbxyhhDxWw6+XD88F1YcFB51oHTD7suY/FVc+2Vr3swou88gKXP2ip4EyvbEMhhmb5zZ
         V4Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=83H04bxF6YUdzZlLQRh4TGz7SNPkoIlEwePAKgXPMOI=;
        fh=JyngvijtTfNthJZ8zOTwjlE97XMrUyecYSV1XX/BihA=;
        b=EWEWGS/isrYj0/q34L2dwmv8TlNpZd6nuCDlktj/Uaxn8bOcM1WwWjbBJDG4+7oZHA
         dmy3dEknapRw+KnhAF7H1HfyvDvnTgYisZoPbvSP5ZvLhWZOhTEv9XJoflC1NsP7CNaa
         LD39lb3tmcWV5le9X0gyWcqzkqMGu7osJXGwfHmgOiGhlld2RSOXl22Aj66kjapRiGCW
         oriZ6tALIJgFYdYfxvlj2IAhxLXsafzeqrzNVVNBiRnHuqYI4fzmxR5K70P7Rb1ulp+W
         ry1fcOe7q5KfJ/gKgN55jFRT//CRY0LuICkKuBh4AmDhZwk52Iqb9S75PQmYHzlj08eE
         N49g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791970847; x=1792575647; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=83H04bxF6YUdzZlLQRh4TGz7SNPkoIlEwePAKgXPMOI=;
        b=cDjmFgQlMljB1thiwDLfsvb0Jn5WJHHkwY535jaC4wY3oMIdQvOvVwULzfPFL4Spfw
         poCtT3cJGFZtTpkiml6lPHdHOZlebxASGGfdNYJ4BdYLgXRwXkq1pNM4QaoraXTOzyV7
         C6JIwqzTkH8Sy9qLoxjtnpJ8Su6TJSS2X/AQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970847; x=1792575647;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=83H04bxF6YUdzZlLQRh4TGz7SNPkoIlEwePAKgXPMOI=;
        b=c157Z9UjvznRvwrjor4hbPpTUFZ9o/hj76HDuwEvEdsG1LTqYJn9F5qaHtWvyyBrCV
         2pQH/9rpMpNZIapqWPuLwunGf/ivJiFq7rBuUWhFHaWCTF4HLu+Irf9/RI/en6B7XGMP
         sVxmLcbfHYcTk2Dv99BK9uUy8X8aJU81hRA9Uf21O389yknd/6/4ols2pnGSDFqoRRUs
         gZ4oyZjYx7lkky+Qr4WHJQcuWb3WrJorr0bOdLboeY92xYl0HaciGtpnABE1bxOLDmzO
         3FpbCHk9JoJ7cpANXfFwpHef25G0IUUSOmMVqkd1UNnaBA+n8DQPcfE3cOo8lXcqJFf6
         FiTA==
X-Forwarded-Encrypted: i=1; AKwUvBzZWDb+3zXDEhn68ByD38HWmZ72XUzZEJ99pbfLGbjo6IySbx5L0E2klIxG9t+9bB824DC8Rc0=@lists.linux.dev
X-Gm-Message-State: AFq9FYIXbRtgo+iQm20Cm9LgoTpU15dYWtLGIlOe14oTGvCQVMhiKOXO
	7M55MTWJ6b5eWUkbmFRuRXrVBvlm4jfoP3Oy0SuiJZiU+EogaffARRFLVRnvtxmQa8k4YvoK1CC
	jUl5/gIcwOWYqjMbbtUSIY55/AuSabizCAECwIqIT3A==
X-Gm-Gg: AYBFou01iAW97GU3cukmKGxoQJL6/f+Hd8jX6wFN9Xyr/cB+aCBxFIYT0OslpMJ0qKo
	I9tjY2qb6A7xw7F18as8QSwdV2RV2f82uZbsodhMDeMQzom3T6uoshqYOWAhhkxF71HxT9RQhQb
	Zfst9R5a/xerV2uk/3EWcWGOkOupqUnu0kOFoik7ukdda+/q+Af2+gVeuAWldU+mcucLbgQ/uxo
	sqhUq5WGJW++IMofZUC4/oiyzxm0DS01kvfgu4Xr5BsLPI1PJ1lbunh28EERZjGBdExekODKpSI
	0Zv9I5PFglXiTleA626d6aNgKRTDH/ErcmmF9y5j4B439ID9Syh2wFfjakfQPtnR8htt03iWSZR
	LjzMhna9HqepF4cmqow==
X-Received: by 2002:a05:622a:305:b0:535:f20:a051 with SMTP id
 d75a77b69052e-535a62041b3mr204309621cf.26.1791970847591; Wed, 14 Oct 2026
 02:40:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261008112004.1899560-1-mszeredi@redhat.com> <aswN-UprZHx9wU9y@groves.net>
In-Reply-To: <aswN-UprZHx9wU9y@groves.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 14 Oct 2026 11:40:35 +0200
X-Gm-Features: AclHuK-4wYzbPDth2dwaMOE-UcJ9Mlv56Q3DJCgmQBZqmD9Im9s183TZ-SA1hxA
Message-ID: <CAJfpegvDbGaoH5Er78M=XYwA6a7zj6DRqY0+F0cgiD7TfRK_Mg@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] fuse: resolve extent maps in O(1) when possible
To: John Groves <john@groves.net>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 Oct 2026 at 00:33, John Groves <john@groves.net> wrote:

> With this patch on top of v4 the famfs test suite passes; that tree is
> at [2].  The famfs userspace master branch [1] now works with v4.  If
> the next revision needs further userspace changes, please base them on
> that branch or send them my way so the two don't diverge.

Applied, thanks.

Please next time use a new mail thread, because linking to the old one
confuses b4.

Thanks,
Miklos
