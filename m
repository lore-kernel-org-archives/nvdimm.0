Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5103CF1ED
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 06:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791442749; cv=pass; b=m8YhMXIbxQCGlxc8Tc++K9zRWAQdU5/5lIxhp3faKAYu6oMjAx8JwU5R87vplco+8Dx6C8wP01BHVAsxrpsC1Fnl3f3M+WEGuIyz7F/mEiOiOpo8wWBMXQBzixn/x0QQemX+4WFues7JR0sIXduWvGQUA/hIHJZ5mL43pv4C9g4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791442749; c=relaxed/simple;
	bh=1W5Sxy12Ogp8A7y6gf9ny6a0gyAw1CRnfeolqgDZBYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s9pHZTMzl4x8Rd+BZsFu4FNVKIMKkqzEPmzOs3n5lVLDqbeDQZ0s/ieFp1MtJzwyj9F6tVnT57J1cXgk3g+NJVQaFLVxMviqXg8XRj94ufvBl72u28hBbdV4trODDuSf+WiXRRu3fwtk4dSsmd3V1aipMqzKrLoheUPdxqFh/gQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=FXzwa5lL; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="FXzwa5lL"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-533797e72e8so29471331cf.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 23:59:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791442746; cv=none;
        d=google.com; s=arc-20260327;
        b=sMzAgAb2v5gmLjYmUwrIAbKX5iRipUGe63SvuEgS263ngjFi2/ozivgFriNe2NVOtp
         nijoygySOnRJ9y/NWsC+NibhNKDyhfM4aQ3qcgcU4bM3tRyDihkqNQe5HJ6zn8V53tZo
         yWuKAjduyFAXsvWNJH7ff14HXpkKEITum3HMiUakFvoU/VY8zw1Hsh2hPyNRwFxlBEk6
         09hAqARryEp8A9h89irRxgMEpU0BaIm4cj8BGRj3xd0IEiO1EOKbQBCL8t+kxJjqWeN1
         GmQEFgWf9aRf8ZRP7JYFqwZrOifTEMrUBVFCFOzfO9vvGVNJdsP1hQTd50TpHPmrzWgH
         RKGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=L3hU4nbWl8LrfKz8yVK4ZzMdYbOShSdSRkPWsTycbt8=;
        fh=/uRGyOBaNdXtAVMljPrIGjGGVsohIgwT/3BK87rWXc4=;
        b=i3JVXDfs6wsP08Sg3YDxMpvii2bACZOx7NQ3omv0ZLy1rlz0Som5rNowjBl/ZO5Vhp
         PH+PFH+M1cvx+PAlXS4HatW+0/k1GHVNyOONVrGZJ5+zxA4ebZqwvAunhY2ZWR9Pvyy3
         9O0mhTG+DP7ScIHAQn2ALie57ueIHX1LlXlw/XNw2uNd8krIiTN3hQ0eR3N1lWrcTeiE
         uAUpnGkRCYYQM+30JBa+JKPO1KAkithbjwp1YuNSZuc9N6XOdCCBIqDdLbkUaGip85An
         IIJ1f1OV3f9aNeI0oiuXJ8TyAaVThEJNyjmhGvycJbk78d7ZPpG3wzSxBDnTRWZxll1z
         0LUQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791442746; x=1792047546; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L3hU4nbWl8LrfKz8yVK4ZzMdYbOShSdSRkPWsTycbt8=;
        b=FXzwa5lLEkNycZjsH7gal961nKdA5A81m9PXGayTSLPv+kUgH1PrUuqNTjzQVoypiI
         3sRC8zwehJLr1JJuUECiLm5mHDbDr8qisDu/BSKQkAiX4q0AKhSTlqlo2RVhqP9ooMPJ
         2KCkg2XPjYqAFywdQkOj/OZ916ytVLsGQjv50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791442746; x=1792047546;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L3hU4nbWl8LrfKz8yVK4ZzMdYbOShSdSRkPWsTycbt8=;
        b=tlgZnKEZIumuMQW77PyhkTMNYXh0LmXiUie5jBABzm1rQQc7O6tJohKJFpNSlJzQ/f
         A8QZQRC/gCTuLRmog5h1Zoqqo8VZ8WqOMLC9xPOWAzDZOgQJasgEMvmIJdzZlmTQ0HMQ
         2WpNzx6bldBzuhA1GAxf3r/nFAAlzFED4tlunusKKF2Hj9pZZ9OL0mUeF6uULKOmer2X
         j9bbopASifJkYRJjjEZPaGeUIpZEL3l6te7f1UoHFAlo6HLK1rpGJ2biJ3y3H/+Ytlw5
         CSXU9a5QwtAaKh0OticS5MvDJNGFKaq96o8pll7bWcNLXlYIRiHyC1Rmxe256RP8rIse
         ctkQ==
X-Forwarded-Encrypted: i=1; AKwUvBxnCVllYR4nVzSJ5XqMlbOJD5eQOcUtvEv/ygpHDTv78KLSyKhfKMpR4NI/ALnaLtSZcrrRi2g=@lists.linux.dev
X-Gm-Message-State: AFuF++msn8xoDkvsaJaiov+okVBTPZmaI5VSdiV986otqfrQV2Jj4Jlk
	oPQrAnz4DvJN0X0ILSPm7Wn5+XxWYVm+yLv7uNRHjqyd1bwvzVTMdkQyaugSxCAeH7cmbUZHZn+
	HmZBBFJLB8FKmtS1DM8iRO+NZsKxG7P1DINgKv9SckQ==
X-Gm-Gg: AYBFou0YkX0a9ldWFr8UAynaJmJjASK/pWt/pqVMvgxyRN59GtztlhGqXZYXLdVfmCk
	OcAkvYOUGTEzewJi1vzm4MByVQl3VMIJ7fxb1ZlFCSdfBD4lMzBj7rMYUPXQt13U6qa/YG12uRu
	wosfHNYTibJUKgyTklRHteLK4tvnO+myoB8mXqlmTyEkQJqxETmeTTvttNh99mMF4weo4i1WwAk
	1tNpgOiLLgBPlzssG4Y0ejgKPRkdUUlpuzNuXjXa0DMMpT5EM8AdP5lM8dajnSH74JNsJ4WpL/p
	arDEM6nAKTQhPmI6i4yMOnqr/NPGDW2JZXmWoo0SlLSNZ9kSaJvwLe+qgHY/D63eLBdq06yWNZV
	nsfoEdWwTvBn4fhYRGZ37xg4=
X-Received: by 2002:ac8:5a49:0:b0:535:10be:7d5e with SMTP id
 d75a77b69052e-53575545a1cmr89724491cf.46.1791442746044; Wed, 07 Oct 2026
 23:59:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261006180115.1425232-1-mszeredi@redhat.com> <20261006180115.1425232-3-mszeredi@redhat.com>
 <asbrrhh0BrBDDOkj@aschofie-mobl2.lan>
In-Reply-To: <asbrrhh0BrBDDOkj@aschofie-mobl2.lan>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 8 Oct 2026 08:58:54 +0200
X-Gm-Features: AclHuK9mcs0U3g8nRj25-jK3khFgy-18rAJm04RUxSKhCvNJcpCBMTzwyQNv4BE
Message-ID: <CAJfpeguxsc2ehKK9cDWx4r8Mk-VNQHGU9Soag=-qzowVkoosxA@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] dax: use READ_ONCE() in dax_holder()
To: Alison Schofield <alison.schofield@intel.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	John Groves <john@groves.net>, Amir Goldstein <amir73il@gmail.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Oct 2026 at 03:03, Alison Schofield
<alison.schofield@intel.com> wrote:
> As written, it suggests that READ_ONCE() makes a non-NULL result safe against
> concurrent fs_put_dax(). However, READ_ONCE() only controls the pointer load, but
> IIUC it does not protect the lifetime of the returned holder.

Right, the changelog was a bit hurried.  Will fix.

> Also, is this RCU-based lifetime handling specific to the new FUSE implementation,
> or is it intended to establish a general requirement for DAX holders and callers
> of dax_holder()?

I haven't looked.  The RCU based fix only works as long as the memory
failure handler doesn't need to sleep.   I cannot make a comment on
the xfs code.

Thanks,
Miklos
