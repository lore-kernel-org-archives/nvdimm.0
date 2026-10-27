Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113908;
	b=eJ2bFJ8YL7Oc6iSSpZvNQkJEW8EL8QwvOaw5bAGZXYVVirqtyV/YEV5uRBXu0P2kRYnW
	 3mnblv/4q3fncUUevtvGdzkRCIYfPcoW04p076d1k1J9o7+Iej5gA+Gg8UXmSOPtSIyou
	 3jjsanzxIHjqUNPA3NOghvMqRdR5gn5Smht7Lae8Sjv8X2M8d77f+Lixl895H8cEduN8p
	 gayAL23nNgKLVqqSA8ts9jIdXZRUARSmUN3nQOfyJ7rBmGZxg+9k8ezbW/N+zhXxV2xSr
	 vKWQPD7eGYf1pySimzIdi7Nx20uW9uFUDwb9qO9OVTUUDDPSSfwrJLc7PU2fpRQ+XrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113908;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:From:
	 Date:X-Gm-Features:Message-ID:Subject:To:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=/yHF5PnPsN1GvzjJzP0bXk8r7xiZvzzSVG//nwgpCjg=;
	b=yuFyp7I6FwhNxls1Mg6HMI5IcoM9X5PZ/s8bJrd6CkIOQ65q1kf2mnBWXBUOB9fNeXNB
	 gxyLR3z2ukW0Lm4SuJ6GOIhB5Ov4rFYQMHs3i/zGJRfhZfVzNqNqRxPSz7NHmJ/cmyxUx
	 4kexbMRa47PNtOcu0oolJeBlo4Y6CP7setWTXOfeP51i/Pj0dr13conMI+zB75FoNyM7i
	 fZ6hpKQwUqTSOYFXOMSdvZjp+ToLNWmAjqg7hh0wUNgXUH5pu3PehLHhRNPAmoIcnLYQS
	 k+Xr66sX/qIIlFcqNWm74VFEJzN0z118aytiNtfGG4lTUO9vBxRtWaHzlPP6Ei5ulZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YnIIJz0z;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B15606A31B
	for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 15:11:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30B15606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=YnIIJz0z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793113907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=/yHF5PnPsN1GvzjJzP0bXk8r7xiZvzzSVG//nwgpCjg=;
	b=YnIIJz0zASn+gFEEUnCEDQ54K8LL53YTuSrzsg5E82aSq8zGD4eD9lROK+94gYnReENAQ7
	qC4ZijUI6b6EIuca4gJ4l3cXWE6qrzrREGqWtnImiA7bSobV1LrdhYXI2w9lsS8/qQXamk
	mjC5pAZsSJCzQTPc3bH5k5r4QxaUpL8=
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com
 [74.125.82.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-270-4b6OacdiMlaQfLSAFt42Uw-1; Tue, 27 Oct 2026 11:11:45 -0400
X-MC-Unique: 4b6OacdiMlaQfLSAFt42Uw-1
X-Mimecast-MFC-AGG-ID: 4b6OacdiMlaQfLSAFt42Uw_1793113905
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-35c3c370b17so7245841eec.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 08:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793113904; x=1793718704;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/yHF5PnPsN1GvzjJzP0bXk8r7xiZvzzSVG//nwgpCjg=;
        b=Jliu8k2XowYkaaJh24Dx8Y5/py1VL0lYHcxOhkjKYyMRUrPxEupsaMSeWVR8+MnWCj
         Atce4Wn4sVCAS02J6O4cU7ff68LllcrQWTyuMhp97h+A/65q2tctlKysaromBvxeI0eE
         kCVvHL1XpDWJnn72zrsdusemcOsWElMS0U1aEypGyPA1t3rlQO9KHUm8uWUBcJvbG2bI
         Prc2GsopsP/2DRDKoyfbAUTpLDx9uFqf8mNxC+PYd15aV7hS8ueLJ4bKNB3kntciPpGV
         j70NuUv5LsxXFsC55wea5TOsrJ7m8Nz7k8GObYyQB/lZ+czxrW1iXHIgwgzZUYVnWIkr
         lFsQ==
X-Gm-Message-State: AFq9FYJ8cwe1NQnfKu1RE062dhaZ1lgiJw9rhBl2JoWTNZEBoWxz8DcA
	4BcyN0rHME7Bay419gu682sFqjhTZa76v2JI+3zmvJWztEH1c7sTS7kXjqpwfs3yDtOVYNVWbBH
	CGWnhQOnfgSZZIeyI3s/3LahSwHgYAdNn2IisZWAPPSC2vZDqSXJ0vEzEfqbVy63/C1NwyGx474
	D4xWk4HDic2SfqU4heqwdA6wfhQWCEm+Xm84IRmUYS/jg=
X-Gm-Gg: AYBFou3tDnZm7C7g7uguXFp+n8GFF4im/dPuwnxJM5a9CRyTv35Qc2KA3Nczozh7naV
	mKs+wzsDQcQ1r9CODdYG41YFT3jj89Z1OiMSyIQJ5RGP47waCQ1GLgjdRHx59TucV/D9/xAfwTo
	+jY+Jr+KEkh8vHUtsto008ca1988O+KTIcN3ZaQLC83Kk9GhhD0/2WmPysPWtuoO+JfW+L2p2Gc
	Jp7Hpr9TmB0z3D44A==
X-Received: by 2002:a05:7301:1441:b0:36a:1470:da0e with SMTP id 5a478bee46e88-36a1470daf5mr2825458eec.29.1793113904369;
        Tue, 27 Oct 2026 08:11:44 -0700 (PDT)
X-Received: by 2002:a05:7301:1441:b0:36a:1470:da0e with SMTP id
 5a478bee46e88-36a1470daf5mr2825423eec.29.1793113903777; Tue, 27 Oct 2026
 08:11:43 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
From: Jeff Moyer <jmoyer@redhat.com>
Date: Tue, 27 Oct 2026 11:11:32 -0400
X-Gm-Features: AclHuK_AvjycSJkJJkYPlN1FDqByfB5KhYY6yhKHTn4Vun-7b2WO2jq1wE6rw30
Message-ID: <CAJruOm8=jt3UxrnCKAahyGY1ownbssM4+PvaSTXHJ89WjpUk2A@mail.gmail.com>
Subject: writing to "bind" and "unbind" sysfs files now causes a kernel TAINT
To: nvdimm@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o3H0mAl7-2xuiLszZLXY9pkIuusbaUDCVBiZ0WzmzQg_1793113905
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

See:
10dde2bd6688 ("module: pull out add_taint_module() to be public")
de2dbaabbc2f ("module: fix up documentation for add_taint() and
add_taint_module()")
fcbfaffee51a ("driver core: add TAINT_FORCED_BIND for when userspace
manually messes with devices and drivers")

and the discussion here:
https://lore.kernel.org/all/20260914-bind_taint-v4-0-eadf8a090903@linuxfoundation.org/

As I'm sure folks are aware, writing to "bind" is how namespaces are
configured.  I don't know what the answer is, here.  I'm just raising
awareness.

-Jeff

