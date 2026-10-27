Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793116488;
	b=ZsLmFWJT8eujtHr/hwF5xMEY8tK71QzgxKvk+xgFMeqOMWZvyr/Yuk1qkNVUnqQGy2BJ
	 qzkJ+BBvWaFgbONLm8fVoQCUbncIMODmXsyAJkqWZQG0izUg0lTdW0h8H+sYk5GtpJu9p
	 2sspafRU/cMrI+XIUmiCJqta7asXPMb+qSrzW1ilE+m0rsYETFM8j5mQHcrGHPdmJN1or
	 sxbDZ6gmhN8STgSY42Idht/x76WbUhD1dWCdq1G6BQXaPOgJhqhAgXI47hXReu7IdFBvx
	 kiWzek8KE34UpWfifc+zxYSgZgbkPA4tZT6K5WO6NtzGWHYN+sINevuy+/eEFZX8Jmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793116488;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-Transfer-Encoding;
	bh=825YnNF4XR3bRtu/EWUBSbZNEw82vlM3uYUurnGTom4=;
	b=js7D8mlQ6aU9YkGdS00qxqkODkwkiFLflijASl5he59iDtzZWtyEBhCry7lUCsP4KCJc
	 ureHIznAZXzNy6locI5YJ4YZSqg+SY1eXob7vJ9cbyntBniKuO6WUSaAZhnlmQ5MQVHUp
	 d9cVF55tLvcNEms2azh3jyK92XcKoY2AvCt2TSBuVI6fo5Wv+OKP04FSueBTPRveyS7EB
	 OSlMbUitsJqQTDGpNcEPGkgLxaajjn1U4A9GWawzBg0nct2jEKXZWnimJwt2oX68ivcW8
	 e9n48KsmcmLiIoq2jFeoWh7QY7T8uGL85BnW6PNqyAjzwhXKTBz8U1kHDv7VDfQO5YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eHxXYbOF;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37A7606A326
	for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 15:54:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D37A7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eHxXYbOF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793116486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=825YnNF4XR3bRtu/EWUBSbZNEw82vlM3uYUurnGTom4=;
	b=eHxXYbOFp/c7/aLoAT8aHa1R4XMA4y+9gC3SUX83vhTlax+ipTBey1LTYVkgtmK8HJMZUn
	NuGfOeGWGg58FslrV3c6ovRTJrLp+OmdDHFOgBW2xOqNaIKkxyqLbM0px41RneuK9QseeX
	x7U/s9l+5uukvYMbufo12hr/bXLHerY=
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com
 [74.125.82.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-b3SLo00bPkiwt7ebv2SoQA-1; Tue, 27 Oct 2026 11:54:45 -0400
X-MC-Unique: b3SLo00bPkiwt7ebv2SoQA-1
X-Mimecast-MFC-AGG-ID: b3SLo00bPkiwt7ebv2SoQA_1793116484
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36637676140so6080eec.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 08:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116484; x=1793721284;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=825YnNF4XR3bRtu/EWUBSbZNEw82vlM3uYUurnGTom4=;
        b=zgm2/yBrk4LlXtcN1mvgZoKpcDBBuW4IgXKZeN/8UEuz5btnOF36riUWmy8PPmI8KB
         IfwW7r++w4KAL0BiozFIQNVQhVlLZgqawHMCeiAS5qH9Y8/Kl/KiDDRAcvmsEEL4zc3X
         DYuijSoWZQu17OsyT9zX7w8sxh06+I4g7XygAwD1fH5txV3++Jz1D5tagb6eg/Vofnhe
         qwBrwq0pjflpOyQ40gCqA6GoJiq1P/HIcPqpBvjv2DcBmJnkhqWM3N3jYYfePCpSWQbo
         3hZbzbc0XbxFBXAFu2yCCLEG0AfAkAEaxT+eJfvudNfKdbdN9bjDq+oyKl+q7IF4kqtE
         wTjQ==
X-Gm-Message-State: AFq9FYLn9O61bDiS9HqyWAoxLAB17HRgFmP1QlLClw1vls+u7SNRranc
	K/AeJOzkt+4Bu6q2yR84vI6lzpKGryWX8VWcDeqckU64munyX5LzhS2mrTZ/wa7h7LhyXvF+yFF
	wGn8zhmBW/7Qgx+4uxvAG8hHN5ZUvpQEyJTA76/3v2w3Tn/1+0xuoSlpSfuogJ4T+wN+r8jVkoF
	Rn6r5lkcjR4FL/m5Q2Bum7SizNJjoTHBROMMIp+vcJ
X-Gm-Gg: AYBFou2rp8PidxCMVE/gNWfdsIW+CUQDSPd+gqO+io0O9ym0E15/czYG1ZmXbq3sPbl
	TQiExqPF0KbS+HeYPr52xQWw4IQupI3aCRZXTEPHKU9N6CV5XZGzRafmhZsV5taNoPqix5qWzdC
	qFCMFS/q1tUTMTrLspz7SSUVEM/BWq6jWyoTNWlz+SLQVntwOofsPmy8ryi5S0zVLDyycSitCRf
	mg5ZkOkX6S32a2WTg==
X-Received: by 2002:a05:7300:8806:b0:368:3568:9866 with SMTP id 5a478bee46e88-369e837ea40mr16105784eec.5.1793116483769;
        Tue, 27 Oct 2026 08:54:43 -0700 (PDT)
X-Received: by 2002:a05:7300:8806:b0:368:3568:9866 with SMTP id
 5a478bee46e88-369e837ea40mr16105756eec.5.1793116483254; Tue, 27 Oct 2026
 08:54:43 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <CAJruOm8=jt3UxrnCKAahyGY1ownbssM4+PvaSTXHJ89WjpUk2A@mail.gmail.com>
 <auDB8NDtiKu8qktd@kunlun.suse.cz>
In-Reply-To: <auDB8NDtiKu8qktd@kunlun.suse.cz>
From: Jeff Moyer <jmoyer@redhat.com>
Date: Tue, 27 Oct 2026 11:54:31 -0400
X-Gm-Features: AclHuK_mhhko6zoT7Nu_HWPVcJms8aFcvm-sLdowaOjNJw2Nmo8KdZaAHp1H1dY
Message-ID: <CAJruOm-B7TyU57RPLtBXPD13wFCTnSA-+g+dE4SZ4Z5KE4dnaQ@mail.gmail.com>
Subject: Re: writing to "bind" and "unbind" sysfs files now causes a kernel TAINT
To: =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc: nvdimm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rzbh2f0WU2LgmKT71iJAbgJhULHVtMsqaPlDbpY5eRM_1793116484
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 11:31=E2=80=AFAM Michal Such=C3=A1nek <msuchanek@su=
se.de> wrote:
>
> Hello
>
> On Tue, Oct 27, 2026 at 11:11:32AM -0400, Jeff Moyer wrote:
> > See:
> > 10dde2bd6688 ("module: pull out add_taint_module() to be public")
> > de2dbaabbc2f ("module: fix up documentation for add_taint() and
> > add_taint_module()")
> > fcbfaffee51a ("driver core: add TAINT_FORCED_BIND for when userspace
> > manually messes with devices and drivers")
> >
> > and the discussion here:
> > https://lore.kernel.org/all/20260914-bind_taint-v4-0-eadf8a090903@linux=
foundation.org/
> >
> > As I'm sure folks are aware, writing to "bind" is how namespaces are
> > configured.  I don't know what the answer is, here.  I'm just raising
> > awareness.
>
> Is that limited to nvdimm or is cxl also using bind?

This also applies to cxl.

-Jeff

