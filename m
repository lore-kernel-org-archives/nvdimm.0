Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07131168
	for <nvdimm@lists.linux.dev>; Sat, 14 Aug 2021 22:34:11 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id u15so985375plg.13
        for <nvdimm@lists.linux.dev>; Sat, 14 Aug 2021 15:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PI1rHatEWX0PgsdhvR2pdSj/thVQ6y4q8Nxx0pg39jc=;
        b=p1x9t2aNBaHGnyuVrfa0m2kZyWdjSl9cvL9d3DGvYfBiyEB0/lw5NuAI0V3pag+5qB
         uB6hPfMRQJcIha1zyl4CzIsWy+84RscMQG+CkRQPPWntIvgFymDdzb3FHVhrNbB8Ql5r
         uO/mF7xfoXK2LnJU3wCi+wkEaHCTgER7NHVbrlTR4JCksOIkDH9dQlf1b5MbiEqeTRS8
         ewL49oWwRGyc6bfIxZ3rLw2TmwfY9SWFxqHMBLZ804BCxbCneNSPMr14qMNSTZie/MTf
         qvj0fotsHMx3xAanWjjZfFr6tefzB7+viOcutPM2ekBioEwo6bM7ui+g9ML06G6GoriU
         vn3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PI1rHatEWX0PgsdhvR2pdSj/thVQ6y4q8Nxx0pg39jc=;
        b=o1laGOd2msuQvcE5tdOJ4p/6KTj7HXDBkIzK/h+7gWbnHy/BaG/x6OBWtBsj7NHmNA
         +QSVWYUPC9ts6m54BnIIdL1iLovNqzqry+yKrks0Zii7Gcf3Gpy2HO1406PtY6HRUrjP
         ZTRXMSu7qzSdnUeFvjqCBDIkgHO17vkYo9vCCu/anODJ2oPZgiE78Ohl31JtFZYXRqv2
         KL9ee8gVTmPP4KUEXb4VfvGN3gYru2v7pVbddO6/M2O1uWha43izA+UZfVOepn8fysB9
         tQq+0YQYky9ZI3bsNF9ZZ9BsPPhV1MUOtZSB9UqDf95yPNM1XkfJlZBkkeMxl/oj+dD8
         +4Zg==
X-Gm-Message-State: AOAM531FJxmjyYbunzSZfTx3JXHds0aaFtFPNxNrBV4OFIaw2EYThiH4
	bgxIHb8k8f+N6N2YO5mm5+94o0oqQRGhoWBY8/xz6g==
X-Google-Smtp-Source: ABdhPJz0PO4aWETtYavvTshIi+MXSwuUyXdhr+bFQ+jlbKCm6IGWh/rBqWCC7E9Z1jXxNkSbK7i8HO9LeBFTzuYFid4=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
 l6-20020a056a0016c6b029032de1909dd0mr8666336pfc.70.1628980451450; Sat, 14 Aug
 2021 15:34:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 14 Aug 2021 15:34:00 -0700
Message-ID: <CAPcyv4iDA0og-BpZWnXY=6pi1GJ9KYpq-f7UkTqSpin1E7rUvg@mail.gmail.com>
Subject: [GIT PULL] libvdimm + dax fixes for v5.14-rc6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.14-rc6

...to receive a couple fixes for long standing bugs, a warning fixup,
and some miscellaneous dax cleanups.

The bugs were recently found due to new platforms looking to use the
ACPI NFIT "virtual" device definition, and new error injection
capabilities to trigger error responses to label area requests. Ira's
cleanups have been long pending, I neglected to send them earlier, and
see no harm in including them now. This has all appeared in -next with
no reported issues.

---

The following changes since commit ff1176468d368232b684f75e82563369208bc371:

  Linux 5.14-rc3 (2021-07-25 15:35:14 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.14-rc6

for you to fetch changes up to 96dcb97d0a40a60b9aee9f2c7a44ce8a1b6704bc:

  Merge branch 'for-5.14/dax' into libnvdimm-fixes (2021-08-11 12:04:43 -0700)

----------------------------------------------------------------
libnvdimm fixes for v5.14-rc6

- Fix support for NFIT "virtual" ranges (BIOS-defined memory disks)

- Fix recovery from failed label storage areas on NVDIMM devices

- Miscellaneous cleanups from Ira's investigation of dax_direct_access
  paths preparing for stray-write protection.

----------------------------------------------------------------
Dan Williams (4):
      ACPI: NFIT: Fix support for virtual SPA ranges
      libnvdimm/region: Fix label activation vs errors
      tools/testing/nvdimm: Fix missing 'fallthrough' warning
      Merge branch 'for-5.14/dax' into libnvdimm-fixes

Ira Weiny (3):
      fs/fuse: Remove unneeded kaddr parameter
      fs/dax: Clarify nr_pages to dax_direct_access()
      dax: Ensure errno is returned from dax_direct_access

 drivers/acpi/nfit/core.c         |  3 +++
 drivers/dax/super.c              |  2 +-
 drivers/nvdimm/namespace_devs.c  | 17 +++++++++++------
 fs/dax.c                         |  2 +-
 fs/fuse/dax.c                    |  6 ++----
 tools/testing/nvdimm/test/nfit.c |  2 +-
 6 files changed, 19 insertions(+), 13 deletions(-)
