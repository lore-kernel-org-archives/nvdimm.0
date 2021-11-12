Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FB82C80
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 19:24:48 +0000 (UTC)
Received: by mail-pl1-f179.google.com with SMTP id b13so9263025plg.2
        for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 11:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bGHTMyksjpTX2amDVy2qutRW78y6rdsI6Emg1cjW3LI=;
        b=TsBoFJZVX90Eg46SWNNVRi3DT9HLG9N6oQcYy3yPoH+dlQkwT2MGZPho21v6SRAYPR
         Xl5XmB5t8kpe7bfdwIPeqlIQH3tk7IDCygkCQoDDorqEIKbHLdQrk20WbLuABFM12tMa
         Pqf4Q1Re0JnheGT9t4B+4oLAndAfep9MzM0uN7bMKIPfewPTWl6QtqeouF8iMVQgfsdc
         +5uvLs3h544ssjbqOVRwbZqH0YIHmJzQEcYE7DjNc14XOABBRDwNMbqVTwuxSc/fRw8k
         oaW7E1PJ4jOwKH4y03naSjmkpiUZ3U17IzCBUjCvHfKOBmAEqpT8y5fa9CmY/9VLu5lt
         gCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bGHTMyksjpTX2amDVy2qutRW78y6rdsI6Emg1cjW3LI=;
        b=Pmmgh/xkwKoECWuEfYQKiUHQmi0l0A/bPxY/j0/SpX9krvtTDUDg5YwzJAXfQryc6a
         z+Gas6vcwIfSAudNLrVN/61sya9Q3I17Lv8QWdhYMKjUJSrb3KGHmJlIVzMiuQ343SDt
         qeYgI5B6JkT5Yd2fP9Mz+HvdnOoau2tN/OMToNWCYOuBeIKixalYb6N1LSowYjjgVeGx
         G/cCznc+Ajp+WkKEzn8xdlPkhcz8Lmow2MFrgDSa03eg+IljJHZOG2ku9TddxAiM7AZK
         wP0iQXOxn1/55ApufLfytwrAw15m2EZt/fP0f538odwcHhjFMvFXARotIMonZl9OygaX
         K4JA==
X-Gm-Message-State: AOAM532oWWUWM0JdYI0tomV2c5JO6c0ZuLO4eUswOcy+14byrA5MPtPN
	maKfJaHEuTW8Y42P0fUNS01WpB+BCr4Y7ZowRUU/wQ==
X-Google-Smtp-Source: ABdhPJxM4yN0AdoSLbsp99GzZWFNfG3IsKhu+eUeWrSi9Hs36hEpIgKKSBd3T0H/xHiGB9aEQFMz84zmTeDzirORH1A=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr20430759pjb.220.1636745087878;
 Fri, 12 Nov 2021 11:24:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic> <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic> <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
 <YVbn3ohRhYkTNdEK@zn.tnic> <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
 <YVdPWcggek5ykbft@zn.tnic> <CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com>
 <YVgxnPWX2xCcbv19@zn.tnic> <48c47c52-499a-8721-350a-5ac55a9a70de@oracle.com>
 <7ae58b24-ad48-7afa-c023-23ccf28e3994@oracle.com> <CAPcyv4imjWNuwsQKhWinq+vtuSgXAznhLXVfsy69Dq7q7eiXbA@mail.gmail.com>
 <f80d03c6-e650-49df-81d1-309dd138de8f@oracle.com>
In-Reply-To: <f80d03c6-e650-49df-81d1-309dd138de8f@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Nov 2021 11:24:35 -0800
Message-ID: <CAPcyv4hPRyPtAJoDdOn+UnJQYgQW7XQTnMveKu9YdYXxekUg8A@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 12, 2021 at 9:58 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/11/2021 4:51 PM, Dan Williams wrote:
> > On Thu, Nov 11, 2021 at 4:30 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> Just a quick update -
> >>
> >> I managed to test the 'NP' and 'UC' effect on a pmem dax file.
> >> The result is, as expected, both setting 'NP' and 'UC' works
> >> well in preventing the prefetcher from accessing the poisoned
> >> pmem page.
> >>
> >> I injected back-to-back poisons to the 3rd block(512B) of
> >> the 3rd page in my dax file.  With 'NP', the 'mc_safe read'
> >> stops  after reading the 1st and 2nd pages, with 'UC',
> >> the 'mc_safe read' was able to read [2 pages + 2 blocks] on
> >> my test machine.
> >
> > My expectation is that dax_direct_access() / dax_recovery_read() has
> > installed a temporary UC alias for the pfn, or has temporarily flipped
> > NP to UC. Outside of dax_recovery_read() the page will always be NP.
> >
>
> Okay.  Could we only flip the memtype within dax_recovery_read, and
> not within dax_direct_access?  dax_direct_access does not need to
> access the page.

True, dax_direct_access() does not need to do the page permission
change, it just needs to indicate if dax_recovery_{read,write}() may
be attempted. I was thinking that the DAX pages only float between NP
and WB depending on whether poison is present in the page. If
dax_recovery_read() wants to do UC reads around the poison it can use
ioremap() or vmap() to create a temporary UC alias. The temporary UC
alias is only possible if there might be non-clobbered data remaining
in the page. I.e. the current "whole_page()" determination in
uc_decode_notifier() needs to be plumbed into the PMEM driver so that
it can cooperate with a virtualized environment that injects virtual
#MC at page granularity. I.e. nfit_handle_mce() is broken in that it
only assumes a single cacheline around the failure address is
poisoned, it needs that same whole_page() logic.
