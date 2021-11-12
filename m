Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E3A2C82
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 00:51:48 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id o14so7120308plg.5
        for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 16:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ddu9Vj9tKLTikV8aAG0QP9oR81wFCLFzzswrwJdy/Co=;
        b=inUTGAixa4vBgsuRAgwHQzwplcdVBndXURyAjq8RDABpm8TgiqPghnn9Vg6zZs5CmL
         LB268VWozLII1iZEUGE0/XGZyl/2QELP8Xa9uraxif4dcw9oF5a3nZyMtlmuagoon/Jx
         EpnmSvxGAVwHf1HZSlOV9qcKqj6U8hIuNTC/eIekn+kiITJmlPCAjTN+r8SOBIuASZ8p
         WEYRMIPr3RZYwfSruCl11rHnoYv9HEViASCOqvu0IF7GKfwfVPRjc0TG6NJ+ToRU+hsJ
         wNi0mX5NREL9khxYa8iwCe1D64e/dFpGOtlqra0ZVsJlCMOyaV/N2O4rowjySFNFqTX8
         1YxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ddu9Vj9tKLTikV8aAG0QP9oR81wFCLFzzswrwJdy/Co=;
        b=b9SEOloaSOAhEmiqhLqdxThROobJ2PGholaERSnNXKN/rUnFqOhAaL2v6yGZBZfmg/
         +fH3AOXgcVHzpGDeRWW5cG986SDyCOiaE2EaJqsvP1Uq0OUpWutE5ONNC/AHz/DayQtU
         4CnxHmqmitReBGO2CDaNsmTLkfmuZcO+AHj0+AtEMCaCUVU/J8vckTpF3VPkst1zCFSt
         7iAjghW2wujWMyzG3XOu7AU9V1pbmMHjReyCHs7z3xscTWPXEezXB8QwzTB0VcjFvOmS
         H0msRGvAdRVz7pD8301AwG0vaA8EX/ITxpXBQ3zQ+zi40fYgK3fEiJvuZk4mCp0MPbOe
         /cBA==
X-Gm-Message-State: AOAM532tM3GOCEHmt8TJsPo2SUulVqKYOvHc0L00S/3jCDTEgAfnmI8O
	JzOsBhs510zP0Fh72BtDzFXl6vh/AtUUDSvBXyrxzg==
X-Google-Smtp-Source: ABdhPJx5yeBPjK7fy9ISsLT10k5i3mQmjAZnYzftMBOFQtAMtYStb0Nfo12XvLLVUQ/F//LswzgQ62bzNsBn3Rv+OkA=
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id
 s15-20020a170902a50f00b001437dec0567mr3635448plq.18.1636678308294; Thu, 11
 Nov 2021 16:51:48 -0800 (PST)
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
 <YVgxnPWX2xCcbv19@zn.tnic> <48c47c52-499a-8721-350a-5ac55a9a70de@oracle.com> <7ae58b24-ad48-7afa-c023-23ccf28e3994@oracle.com>
In-Reply-To: <7ae58b24-ad48-7afa-c023-23ccf28e3994@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Nov 2021 16:51:35 -0800
Message-ID: <CAPcyv4imjWNuwsQKhWinq+vtuSgXAznhLXVfsy69Dq7q7eiXbA@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 11, 2021 at 4:30 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Just a quick update -
>
> I managed to test the 'NP' and 'UC' effect on a pmem dax file.
> The result is, as expected, both setting 'NP' and 'UC' works
> well in preventing the prefetcher from accessing the poisoned
> pmem page.
>
> I injected back-to-back poisons to the 3rd block(512B) of
> the 3rd page in my dax file.  With 'NP', the 'mc_safe read'
> stops  after reading the 1st and 2nd pages, with 'UC',
> the 'mc_safe read' was able to read [2 pages + 2 blocks] on
> my test machine.

My expectation is that dax_direct_access() / dax_recovery_read() has
installed a temporary UC alias for the pfn, or has temporarily flipped
NP to UC. Outside of dax_recovery_read() the page will always be NP.
