Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299DA70
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 22:47:39 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id k2so4660813plk.13
        for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 15:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OztpKFyFkHWq5WmztlCUxj24iVog+SfKlFUjwOQEcIM=;
        b=Ee5VvOM4+VyN0yPauYS9IvJ9A6xbJ1FPxuOaat69KAXUI++RH/9oGYOP25DAXvA7ub
         u2kQW2QMmNNyt8vw2iAeV6dJp19mwcmf0au7qoDzB8vLkFPpSwha1GKZw6ufXzyPKV9C
         WFCM7Fpr+gVD898Q2Dr+ziDEZe8H7y0XyX/ijFkSeBL6iquo+wLgNjsP3eNbWmeukcL6
         XB2zUp6erLruYx+oc6ptvw4HXUGo0ek9WmK6KL74voFg2erwcoC3TVr7jlMfrkdNwm3E
         yTxM+V5ISgNrFkEdpdXwZWZEmpeOpUrQvlgqWPgAmGQPUUrIpS9iedbAJS7cK6Y0MzqB
         KWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OztpKFyFkHWq5WmztlCUxj24iVog+SfKlFUjwOQEcIM=;
        b=XIh8/jV31OtSwqbtw+cwk7kjoSkk/LUGpP04xXY4tYRFY92FuX+rz6Obfmmh+QLsa3
         8VKsEya59wNgboEOUfplmwrIFzKkWfSky+5ot/mHAoXcJn7uBV63b/Os8bh2BSJDhY7P
         DwBtEwxtbBm1Sd8gcVEHsxtfyMEcSnkxy48KiuUE9UV2YqrQTIi3GOrE3v/xlVnvKnzL
         F64nG5BFJomtYyVRTgHKJRZTUOrBQFjxCCVbnkEsrodEz5zTKAizP19tkDHmyy7yuVK6
         hgdzCOSxhTi58CfUZYnobCopPm1b7KyQp9R6p+xoql6o3YsVu5Fh/RjkkWgtOKpKUEnn
         7HoA==
X-Gm-Message-State: AOAM5322+OaGNcH9xnG+jCptaAZSxdWfwitBAzMStpbCQTu2z+iDGGXa
	XdI32jBACClu9fS/tLjAbhrQG6Zbd6dqYHCPbRK2Yw==
X-Google-Smtp-Source: ABdhPJwPiM+NKEtruzRpK/NiP66bEuzTYZ4j9DmM8ubfJBKgrpBiXCa+LC9RkMHZ7UAJFPKXOAuDfLO0UiUHM5H7org=
X-Received: by 2002:a17:90b:18f:: with SMTP id t15mr12593468pjs.168.1628722058608;
 Wed, 11 Aug 2021 15:47:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
 <162854811511.1980150.3921515741758120378.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210811194905.000034f6@Huawei.com>
In-Reply-To: <20210811194905.000034f6@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Aug 2021 15:47:27 -0700
Message-ID: <CAPcyv4gZgkTtoVhMR+YWZHv2P9xeBQ3-a_2nRQ6euSQ-eaY5Jw@mail.gmail.com>
Subject: Re: [PATCH 09/23] libnvdimm/labels: Add address-abstraction uuid definitions
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ben Widawsky <ben.widawsky@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	"Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 11, 2021 at 11:49 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Mon, 9 Aug 2021 15:28:35 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > The EFI definition of the labels represents the Linux "claim class" with
> > a GUID. The CXL definition of the labels stores the same identifier in
> > UUID byte order. In preparation for adding CXL label support, enable the
> > claim class to optionally handle uuids.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
> I've already commented on 10 and 11 so this was backfilling tags
> for the ones I'd looked at earlier but looked good to me.
>
> I'm not all that familiar with this code yet, so all my checking was off the
> "does it look locally correct?" variety.
>
> Out of time for today, and not sure when I'll get to looking at the remainder.

I appreciate the slog through this legacy nvdimm code!
