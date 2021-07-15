Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C842170
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 03:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1626320372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QladtqOzUbqQSEvoFJM1W1WMC/wSc3UWTwSvSmfi+cA=;
	b=awLhaQK6uxx6tBAAxlOo2TWVU7InOTmWNyoVtx4eOKTDETtVD/zicJPqJimDFyolp9iNjJ
	peGbnNG4FrNEv71PUAZE74pjDDBsXIYrp4rGY5CtH5mP8FjQFEwJbgjVx1nRgvolto/85l
	qzCunV0vTq61xD34oDnuJ1ZSgl+Xkn8=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-KbJqiiFOMtWxJw81-J8ieQ-1; Wed, 14 Jul 2021 23:39:31 -0400
X-MC-Unique: KbJqiiFOMtWxJw81-J8ieQ-1
Received: by mail-yb1-f198.google.com with SMTP id k32-20020a25b2a00000b0290557cf3415f8so5948320ybj.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 20:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QladtqOzUbqQSEvoFJM1W1WMC/wSc3UWTwSvSmfi+cA=;
        b=U3HFSaz/dfukMlBBTDl65n0wiTKPSdXo5k9dNJA5QyA4c+cqb90aplpSu85u9MJaF+
         oXfet94luHmK8JEt/NRBNF+CY00KF+m8zDvI8kpS/KnmqxcYGbnoP9JGpLLHWFSLbwsM
         3acUlNY7L/k3JfP23WEIahaInbiKLvBta4vDDXNZ9WyUE4iJE36bx2jDakXVMBE8WiOx
         13j4/tpeLZa87xQarJenJR7NxGJEdylJpO0UOCOt4aQxWP4OONW/K5BozmsTwWY3fXyl
         fz24h4quNtQcdiozEvKUZb6gViyIQ+5o23HI1H8Nf4+mutGpUimWWzew3djaUYvMS6c4
         sOGg==
X-Gm-Message-State: AOAM533rTxEqenKNExWHICOJHxUAek9Vu8vJ+8JQP0viDd2CSWuTUwzZ
	baWADoWvNFxpDJ/Hj7RyEPdGUunb6bxGOjKBr9VwUGHMg/1zyXYc4hZZQFrlIZwD6lNzIOQ5c7w
	6bv5m4gV/LH4pLQPfOAz6UaNDid6n+jju
X-Received: by 2002:a25:324d:: with SMTP id y74mr2087207yby.198.1626320370799;
        Wed, 14 Jul 2021 20:39:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMPfu7pKMB+tMw2KlLA6uuElwAWIYDzSBIpNzpRdggUDllkV+qAMv8+TCawruEIoV6PnNROMDbcYSZbEo2ebw=
X-Received: by 2002:a25:324d:: with SMTP id y74mr2087191yby.198.1626320370644;
 Wed, 14 Jul 2021 20:39:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708100104.168348-1-aneesh.kumar@linux.ibm.com>
 <CAHj4cs_t9sMw9b5XRPMkYE37BfAEMkWCFFpU1C8heKYBbRcnbA@mail.gmail.com> <CAPcyv4iP50kaPk8fVmPOMWbVngeLmEhC9nsEBnhgU0C-Er0U+w@mail.gmail.com>
In-Reply-To: <CAPcyv4iP50kaPk8fVmPOMWbVngeLmEhC9nsEBnhgU0C-Er0U+w@mail.gmail.com>
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 15 Jul 2021 11:39:19 +0800
Message-ID: <CAHj4cs8N4r-az27Ljt9bTu9DcPnrWK_snxdY6xDGm=hjr3FKhA@mail.gmail.com>
Subject: Re: [PATCH] ndctl: Avoid confusing error message when operating on
 all the namespaces
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=yizhan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 13, 2021 at 1:16 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Mon, Jul 12, 2021 at 5:20 PM Yi Zhang <yi.zhang@redhat.com> wrote:
> >
> > Jeff had posted one patch to fix similar issue
> > https://lore.kernel.org/linux-nvdimm/x49r1lohpty.fsf@segfault.boston.devel.redhat.com/T/#u
> >
> > Hi Dan/Visha
> > Could we make some progress on this issue?
>
> Apologies, we had some internal administrivia to address, but are
> getting back to regular releases now and catching up on the backlog.
>

No worries, thanks for the update :)

-- 
Best Regards,
  Yi Zhang

