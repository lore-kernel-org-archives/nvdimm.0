Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A4872
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 21:06:19 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so329784otl.0
        for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 14:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OYyYyBrpisGgGv4u7uF58EpIGDb+offxJIbk4f5laJE=;
        b=hxbk6iESAbbXp32/9M14/IdPiUNbfMBgA1ng9Z1wDSyK5+Mrt4OJ1CoZh58+Ktz16o
         oDPHdAfWIVFl4ykzSgepL1PWHUe6meH81cNghwyRcj20ayxQkdIi1WXJEzoyEy6kiWwU
         xaJyLc1OrDot4k4cmO6NS/XqjS7RI8Z0ZUwCTfQn2Op/IMJ0DGdWgQ/kvr8WORNwvzZO
         Oyi14+y7QASGdw71wC9bMpRC09e3zpnA9uI8b/5oIIJNdzuYMcm2/sKawOsUUlDilPZP
         OjXHoTEawzX64/NAJV+nyXzftFBQes9mCvWWqkgRZg0xO/w8PmGQta167qc8ANRy4BKI
         YWdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OYyYyBrpisGgGv4u7uF58EpIGDb+offxJIbk4f5laJE=;
        b=m1dkVIaxGjABQqoHKAthgcVvvJ2TeVaXxkXdypo+HMB9czk+Y+yaMRcm+OmIAXzfpf
         oDx8ATVRNiq2BnZ2DXuXeTOi9qNP0Ui5UOSH02T8SpNz0WUTl1nTRfPfXpxJY3xkFiib
         5WkwgzNyOJLvzcJj4MbrIgN5G1Vre9/kx4oouNxuMN2F0vLzvGyyXZRbLIjWTy9bvf1b
         8IEZ/YOFLWK/shenaJrnaNWQSXUzbV02L7wH9eniUbVnfFpHZ/aR5nkDajteAJQTmwkA
         pYcOdWPkDiOvpIZsSpQLzgzheCb0kAWkapXLRfcHBN9qmPXN4oddwYiQF0sjPPGH8Tms
         /cSw==
X-Gm-Message-State: AOAM531wiyZ5fVXPyhn9CNJCWeo54VepVShVBsBxok6//qnqMqB+AiDz
	t+9jM0EZJYnTS6iPUej4RReBo4j0cMzstGLKiO++JbmyjsLd7Q==
X-Google-Smtp-Source: ABdhPJznAirmWAy0hc4BenVdeYAT0VZfL6UHcsts5QdNcmLkX+l/8xbpDeGxfr36+E3NEEGhVzaDSKm9ypQj5oKC2os=
X-Received: by 2002:a9d:72d3:: with SMTP id d19mr5166333otk.7.1626210379058;
 Tue, 13 Jul 2021 14:06:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210713202523.190113-1-vaibhav@linux.ibm.com>
In-Reply-To: <20210713202523.190113-1-vaibhav@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Jul 2021 14:06:08 -0700
Message-ID: <CAPcyv4hnZSzcG3uc0BLWBjhbqBwJLsCeUPiAALwubHoXge58NQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl: Update nvdimm flags after inject-smart
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Vishal Verma <vishal.l.verma@intel.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Ira Weiny <ira.weiny@intel.com>, 
	Shivaprasad G Bhat <sbhat@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 13, 2021 at 1:25 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
> Presently after performing a inject-smart the nvdimm flags reported are out
> of date as shown below where no 'smart_notify' or 'flush_fail' flags were
> reported even though they are set after injecting the smart error:
>
> $ sudo inject-smart -fU nmem0
> [
>   {
>     "dev":"nmem0",
>     "health":{
>       "health_state":"fatal",
>       "shutdown_state":"dirty",
>       "shutdown_count":0
>     }
>   }
> ]
> $ sudo cat /sys/class/nd/ndctl0/device/nmem0/papr/flags
> flush_fail smart_notify
>
> This happens because nvdimm flags are only parsed once during its probe and
> not refreshed even after a inject-smart operation makes them out of
> date. To fix this the patch adds a new export from libndctl named as
> ndctl_refresh_dimm_flags() that can be called after inject-smart that
> forces a refresh of nvdimm flags. This ensures that correct nvdimm flags
> are reported after the inject-smart operation as shown below:
>
> $ sudo ndctl inject-smart -fU nmem0
> [
>   {
>     "dev":"nmem0",
>     "flag_failed_flush":true,
>     "flag_smart_event":true,
>     "health":{
>       "health_state":"fatal",
>       "shutdown_state":"dirty",
>       "shutdown_count":0
>     }
>   }
> ]
>
> The patch refactors populate_dimm_attributes() to move the nvdimm flags
> parsing code to the newly introduced ndctl_refresh_dimm_flags()
> export. Since reading nvdimm flags requires constructing path using
> 'bus_prefix' which is only available during add_dimm(), the patch
> introduces a new member 'struct ndctl_dimm.bus_prefix' to cache its
> value. During ndctl_refresh_dimm_flags() the cached bus_prefix is used to
> read the contents of the nvdimm flag file and pass it on to the appropriate
> flag parsing function.

I think this can be handled without needing an explicit
ndctl_refresh_dimm_flags() api. Teach all the flag retrieval apis to
check if the cached value has been invalidated and re-parse the flags.
Then teach the inject-smart path to invalidate the cached copy of the
flags.
