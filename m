Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849F1168
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 05:16:40 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id j199so18501107pfd.7
        for <nvdimm@lists.linux.dev>; Mon, 12 Jul 2021 22:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EReW33THqwozhjWL9w8CAHxv1rzfSmgs9bOr6uiuybw=;
        b=0tf44N8g+owE1CgrIVnvv1CNTpT/JKB3/GnWuxE1B+PIKExmkWBdwT2v8EKlPD281m
         cNdJh4j0K23Co8SloGgXOP6MqaHsbbgN7p652Up+Qkflkx+NuMNHDnJ9g0+rwIFeq8Un
         6J+Au+Zuj+RvbYbEe9D++ZswMSEZpYRRozqYZllcAzzNQiukA2jmpnyQdKE1t0oDs1by
         M+Rr16D3mF4q2XSmn2cbCJmI/J9iudB6ef6caZERumWkUj5PxhU/Kgnsll3IHOKsA0MA
         zvhRu2FmK19DfNjoWAd4fCGeq31pSxTCTYTZW22ok6QznfNRvjEH9AjK1qb5Z1npGJNB
         xOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EReW33THqwozhjWL9w8CAHxv1rzfSmgs9bOr6uiuybw=;
        b=c649JThVak7OVt785PG7gZkGcCmqq96K65cijWOUfzHqff7Ma6mPgEfmx7crHM84s6
         LQeqPIFk9/4MIkyqDsp9LfafrHlCM0PIaH26IasA/m0Un7GYq+jWnLLeM0Aqcp/NmFTL
         4XEYwnuTlcAz6zl7jOEnI95isoWcuVzDGF/fXrVK9Ssr4bdpW0kNG0XZbfRcFWIlkADE
         u/hCzMANDvjRXkkGJJOZJD18l4gtLJOD2PctpemQS8cCxWwa7alnLZeC4QRa7tAf0pi5
         xH2YAt4uRbDcgqwt8x0UI0Rg9foYhvrTnDcHDABfShkca2ixo0wh4dMYUp879JKv256P
         yYZA==
X-Gm-Message-State: AOAM530dTiIMxQi6N/GiZDo+gXzNnaP02Pmh6usfJ4CKteoXU18LqxQg
	PPy+vQ0WJceNzX6Pe0pmS98a1YThEBL0sd1SjJrtVw==
X-Google-Smtp-Source: ABdhPJw0edWt1M1gyFgaAvyvMc+L4nsV7isEHVNR8a7V7gg/xKPwb+lkTspKd84G1MAAqlgI3q6UXxdTWhgvMkuVMjc=
X-Received: by 2002:a65:6248:: with SMTP id q8mr2634320pgv.279.1626153400078;
 Mon, 12 Jul 2021 22:16:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210708100104.168348-1-aneesh.kumar@linux.ibm.com> <CAHj4cs_t9sMw9b5XRPMkYE37BfAEMkWCFFpU1C8heKYBbRcnbA@mail.gmail.com>
In-Reply-To: <CAHj4cs_t9sMw9b5XRPMkYE37BfAEMkWCFFpU1C8heKYBbRcnbA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Jul 2021 22:16:29 -0700
Message-ID: <CAPcyv4iP50kaPk8fVmPOMWbVngeLmEhC9nsEBnhgU0C-Er0U+w@mail.gmail.com>
Subject: Re: [PATCH] ndctl: Avoid confusing error message when operating on
 all the namespaces
To: Yi Zhang <yi.zhang@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 12, 2021 at 5:20 PM Yi Zhang <yi.zhang@redhat.com> wrote:
>
> Jeff had posted one patch to fix similar issue
> https://lore.kernel.org/linux-nvdimm/x49r1lohpty.fsf@segfault.boston.devel.redhat.com/T/#u
>
> Hi Dan/Visha
> Could we make some progress on this issue?

Apologies, we had some internal administrivia to address, but are
getting back to regular releases now and catching up on the backlog.
