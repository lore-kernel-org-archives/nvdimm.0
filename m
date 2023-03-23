Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D79915B4
	for <nvdimm@lists.linux.dev>; Thu, 23 Mar 2023 01:43:13 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-3e0965f70ecso163391cf.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Mar 2023 18:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679535790;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9LlKFIUnSiiyDV3W4CcAc2xVtnCFtBb9VdMUxb4jw44=;
        b=SrlTMZmYgOWH2+lpIr/3B4bXeXk2h9EtYR6hMRGQPunkoAQiPnt777dvmzlY7q8vFu
         cTqcdLypbh6S7gcResJEcj68suRCTCnSf3cN6r5PSgQnVjd/IZruAoURU6WrhfBpRrwo
         3bbI34wK7oEr7BOA6n2r8XoZhLyPI0DvSNLm+fW5omdFGSwc5jKYkfqZD7okHOWUw2ZF
         l6xQsKRWKlqYF1M9Th/1uoXJs0ngkk2WFZyx65S5wvHPPQRZ5uyaw7LY2WrAsgxGPGM8
         DHXLLhc2FoQCDaSUiIdK0nvDZ/qE37ZCRTPK5ThEhcfCrRM7zORlxhlIT0crmm5KeLdb
         QTaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679535790;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9LlKFIUnSiiyDV3W4CcAc2xVtnCFtBb9VdMUxb4jw44=;
        b=ydjujGL5LIbAOF0nT9yozagUD5TvC3wZ7Vh2YtsE5KNt0PVGst3bh3uSFrmUhen9Ff
         /pDda1TOdp3LEVXvaCcLEpiyuQZC5iKdA/tQPA1TWZmSQ0WoNZNGZaHlVuHTDcYk01xk
         92HZ9xedIq6bjTzrjzKMJ5rs14Qkv4FZmBQBtDYyOjPpVyXC7N54I7Z3OHCnuwAA9QDQ
         gsLHRIGDJze4h8AaGai1wr7QuwyrzyqTSA9QcKGc+Rt3i+k1kxR/Z3o6ockvWewi99/W
         IvOfT78kcvu6uHxghZtY4OuxiNWFnm5PHNMv8E/JLZPgnpzoQ2O2qzB3o92vcwp/XVFv
         fT1g==
X-Gm-Message-State: AO0yUKWkOTNu6uCCj3+nGz/GWjivvf8kSRe+ALZjF0CRuf3zm6RMPHZI
	ACqeUlSlaw7awQPFdoSCadoHWG29DUlU9IafXUP9RTXgDBUD68gPttT2yg==
X-Google-Smtp-Source: AK7set9qTOJdeJ55DXen5M7F1pIehc7zwBpS5B15RCsnb+/+t7c3VOg5Ek4FkVqhdrSnXw21/2sKAB7P0o0g9Gsn19U=
X-Received: by 2002:a05:622a:312:b0:3c0:4e06:764d with SMTP id
 q18-20020a05622a031200b003c04e06764dmr742874qtw.16.1679535790114; Wed, 22 Mar
 2023 18:43:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Ian Rogers <irogers@google.com>
Date: Wed, 22 Mar 2023 18:42:55 -0700
Message-ID: <CAP-5=fV_A0A8-BnfaWFoXX2a284UDp8JHvaBLC_FXPzW5GT+=Q@mail.gmail.com>
Subject: Determining if optane memory is installed
To: nvdimm@lists.linux.dev
Cc: linux-perf-users <linux-perf-users@vger.kernel.org>, 
	"Taylor, Perry" <perry.taylor@intel.com>, "Biggers, Caleb" <caleb.biggers@intel.com>, 
	"Alt, Samantha" <samantha.alt@intel.com>, "Liang, Kan" <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Hi nvdimm@,

In the perf tool there are metrics for platforms like cascade lake
where we're collecting data for optane memory [1] but if optane memory
isn't installed then the counters will always read 0. Is there a
relatively simple way of determining if Optane memory is installed?
For example, the presence of a file in /sys/devices. I'd like to
integrate detection of this and make the perf metrics more efficient
for the case where Optane memory isn't installed.

Thanks,
Ian Rogers

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/perf/pmu-events/arch/x86/cascadelakex/clx-metrics.json#n1134
