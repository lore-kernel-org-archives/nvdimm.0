Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0030EA6
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 20:59:59 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id s14so5400373plk.8
        for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 13:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLKD2dblooicmntfeXJvcRLmX0XCmID7Bco6CZgoNrs=;
        b=QCkkZYrap++Utj5fIp+D5MezgUIkURFbeyVSdCZ3U6/QHNGkao3oNv+fENEf67G9Au
         brpdZEYjcnUhT+lQMjIEslrQw9pic+lXkGfOlmfbeL0N+CIgagdzSThJa25nALVM5Hjs
         av4+5OzzswgFjAWiLNX/c1DhfKHtTOu4b9JHeXQkOhBnrK3Swx+LP73ItFxdRXdlFD6+
         BmTnI+MrJpC6YvROV+5qYwpYKYrkcSc7aIUIcy1LR+7u+9Isxc9KCAAS1ZKoKSPCEHp0
         MFGmQvQRKYE6jQG2Ja2A0ZmQ0zo4adGFmk4ZNsWItWV6c9jLs/wbZ1PFHJrd5aSIyTT5
         e2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLKD2dblooicmntfeXJvcRLmX0XCmID7Bco6CZgoNrs=;
        b=WjsPe68PRqboPyOMHN9X1viNleYvoTL84u7altuCMp8CeuI+qatEn+vhdO3B+UEcKs
         MF9TEK/CzAmp2IYCQAxeAMpVpCgMrzFwcyo3Y5Yjd2+R1THTwmr0+VoeBDUB+JVEjMW9
         fRiZdkW09NavZhfQXq54pPtuJKCzbluTvjnIYojrZNZEtqddrNcrXBEzmB9qcFnDovY+
         MAHR9pJmF4DKBXLZk1TC2kL99WNCFXkAXbFAFRW9EIOdv/4FSIFfZzgrvMiVI9Xg45TS
         zoX/wMZ0oYCzr/TCm5F27b6ADCAi98MkTosmlXmoBjPlfavAYoKIV+GUvZr7WBLjZO1l
         VlGA==
X-Gm-Message-State: AOAM532X/+PH2mgggWCopc96W2wlx+nQrmXmY1YxyETz6V9UGKB/PAfP
	Wd0bEIMHPILR0EX71ZcdGrjOnMcJBjI7R6xcEA0XZw==
X-Google-Smtp-Source: ABdhPJyWThGFQ5e2B7qzkv/rYsXy6BBru3WAyJ6flsbWwKuN4McM4GvTLEtcgzb6GM8a/vSLd/o5TnAk2JFQkgRVpKk=
X-Received: by 2002:a17:902:da81:b0:15d:37b9:70df with SMTP id
 j1-20020a170902da8100b0015d37b970dfmr15084382plx.34.1651179599335; Thu, 28
 Apr 2022 13:59:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220428190831.15251-1-msuchanek@suse.de>
In-Reply-To: <20220428190831.15251-1-msuchanek@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Apr 2022 13:59:48 -0700
Message-ID: <CAPcyv4gep_fFiYYRjE_kfeur75xPaTZx6s5v+fuWBmNucvQytw@mail.gmail.com>
Subject: Re: [PATCH ndctl] test: monitor: Use in-tree configuration file
To: Michal Suchanek <msuchanek@suse.de>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 28, 2022 at 12:09 PM Michal Suchanek <msuchanek@suse.de> wrote:
>
> When ndctl is not installed /etc/ndctl.conf.d does not exist and the
> monitor fails to start. Use in-tree configuration for testing.
>

Looks reasonable to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  test/monitor.sh | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/test/monitor.sh b/test/monitor.sh
> index e58c908..c5beb2c 100755
> --- a/test/monitor.sh
> +++ b/test/monitor.sh
> @@ -13,6 +13,8 @@ smart_supported_bus=""
>
>  . $(dirname $0)/common
>
> +monitor_conf="$TEST_PATH/../ndctl"
> +
>  check_prereq "jq"
>
>  trap 'err $LINENO' ERR
> @@ -22,7 +24,7 @@ check_min_kver "4.15" || do_skip "kernel $KVER may not support monitor service"
>  start_monitor()
>  {
>         logfile=$(mktemp)
> -       $NDCTL monitor -l $logfile $1 &
> +       $NDCTL monitor -c "$monitor_conf" -l $logfile $1 &
>         monitor_pid=$!
>         sync; sleep 3
>         truncate --size 0 $logfile #remove startup log
> --
> 2.36.0
>
>
