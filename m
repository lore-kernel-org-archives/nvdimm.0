Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293A270
	for <nvdimm@lists.linux.dev>; Thu, 22 Jul 2021 04:40:40 +0000 (UTC)
Received: by mail-lj1-f181.google.com with SMTP id c23so5736733ljr.8
        for <nvdimm@lists.linux.dev>; Wed, 21 Jul 2021 21:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FqaF1toTkZO1aIkjtXOKxydI54vBBJOz0yz3CPG4AT8=;
        b=ZFksZed0LXtmImxmSANOpFmEtvY0GG7XmtNlDRjMTQhMRKaAzYe57EUcDrKcUg6H17
         S9rWGY+V5UfK2i8WDGYEfXfe4vNN+2B7CDjY0vagKHUdIcNTxscOsdjp6A54ySJ3dt5k
         bbgbm4o/fWdixjfAGISDUeTJbR/V6orVWgktJ+TnJ+QuT/jLulTb4AJSsn5F+ZWgtPOV
         fHmgoSQHsfzo/nZRqaGP8gZdPd3hai3EF/tyzEVuo/hPiX0tZwuKLY/wWEgb5UQMtPyj
         BQCYZIWit1gOUocE6LToEDkSVP3RfLhjZ70amz8rkYtKm75Di1U3mUpPVEYQMLJxE6+/
         6AYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FqaF1toTkZO1aIkjtXOKxydI54vBBJOz0yz3CPG4AT8=;
        b=j/ZEWzjyzY06HpIcB/Y2gVfkjThIHDA2ogB36pQGXIq0GEB675o5RWMENbSZSMN3h/
         shzPcT/JoutqyxUHOzlJm0A32hsiaZmmhyp0H1T8sOIeU4XFhCsS8aPr0soywj2aTfo4
         lnSvTwxBUcWC1WgL/axlQFuDSICaq6qPSokg0VrD6FzShm8qEh0ELgXh/MLuAKYM3oWh
         KzdRJgmbZH2ozYdCvheTHbpiWupTES0fGBCDg9Zb+YwvH2rC63LY1yqcZPxeWZZVnhJ0
         GDYJ+FlgYkinAVCtd0qIz7sQ7ZB9cfqMbnMkKqRksBb8xlrSWiIhD7Arl5sQ10o6EE+c
         ZEyA==
X-Gm-Message-State: AOAM533KeXMmL7u0/Fvb41G1VjoAIqNuHWat6tZz6Z56kuSq/qeJ7M9i
	EGk3TUh3kpoJ6ABqe2keYQS9FW+85SW8PX3Mjx36Fw==
X-Google-Smtp-Source: ABdhPJyBmJ8x9rdIZ7PzfEct3U03Dmp5hp5gN6jd27mrCPUZt2BEIfrNIkVgotqTJTuFY+GFXQtCRmZdzV3mQU6S1Yc=
X-Received: by 2002:a2e:bd84:: with SMTP id o4mr32736094ljq.334.1626928838170;
 Wed, 21 Jul 2021 21:40:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210715223505.GA29329@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAM9Jb+g5viRiogvv2Mms+nBVWrYQXKofC9pweADUAW8-C6+iOw@mail.gmail.com>
 <20210720063510.GB8476@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CALzYo30-fzcQMDVEhKMAGmzXO5hvtd-J6CtavesAUzaQjcpDcg@mail.gmail.com> <20210721220851.GB19842@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
In-Reply-To: <20210721220851.GB19842@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
From: Pankaj Gupta <pankaj.gupta@ionos.com>
Date: Thu, 22 Jul 2021 06:40:27 +0200
Message-ID: <CALzYo30TneZqhR4Uz_=sWVpzr3Y3VX9d=3dYMe-NbvF-yYessA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] virtio-pmem: Support PCI BAR-relative addresses
To: Taylor Stark <tstark@linux.microsoft.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev, apais@microsoft.com, 
	tyhicks@microsoft.com, jamorris@microsoft.com, benhill@microsoft.com, 
	sunilmut@microsoft.com, grahamwo@microsoft.com, tstark@microsoft.com, 
	"Michael S . Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"

> > On a side question: Do you guys have any or plan for Windows guest
> > implementation
> > for virtio-pmem?
>
> Unfortunately, my team doesn't currently have any plans to add a Windows
> virtio-pmem implementation. My team is primarily focused on virtualization
> in client environments, which is a little different than server environments.
> For our Windows-based scenarios, dynamically sized disks are important. It's
> tricky to get that to work with pmem+DAX given that Windows isn't state separated.

I see. Thank you for the details.

Best regards,
Pankaj
