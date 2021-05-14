Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08CC70
	for <nvdimm@lists.linux.dev>; Fri, 14 May 2021 23:33:34 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id w3so951751ejc.4
        for <nvdimm@lists.linux.dev>; Fri, 14 May 2021 16:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=1+NbqxnUts2cERrUKprfSG6COch8OgsrINoj1msojwQ=;
        b=SE78uhsaW5vmO2PQwNgDVDEFZaLmLd2hYDNZhtr9Nt/nw9Asyt0kF6wBIRcaCQE94q
         iFo9NmUEMIp1hQL34Xw1iwYmf+UkAl2N+08lUDF845tzB4wZaLM/OM2gen6ONHUtYSz7
         CpZ1xfTo2Jg4UJ9OutADhkb19GX/5HMflMJF05nLMyzn5UQuaGvwkMIMASnORPA3Rd/P
         FgZ1/x3PNkA7FZCp8OHCYRsQxDUyfrhsvaBWylUAX4Glxf2WL1OoaFEoTsTPAbce7R3Y
         l10IgmrP7DIItHPkINgy5dP9A30nU7qafs9JueEYbZP/3+8ZFpGxN6oO2AultOlrolea
         smUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1+NbqxnUts2cERrUKprfSG6COch8OgsrINoj1msojwQ=;
        b=LqjO8oEDq2yEmvtDWRRCNE5mNzVE/jXgN5IIqIuXZfwiqyrSjnq63xTDahsI3+x95X
         HrnH+29anX+ICZr7894EkJTP15KMAiwykho6wdiFW40eLR98ruqV6uVCweqRJagxLreL
         WWmaZvAo9OD/DDXvKAu86DcM6bGNj5d9IM2O3l969VIag47LbCv8i8JyL0cgT/zF99AU
         IBuDzicJxnuCfrGBukf52ejsjf3CYMDBgkN9IMfJcJrvjoP0SI9NEPkND8PBg0j1ERhf
         NERRjFN6Pl8yi6/EpPqUUYFSZu7XFFrU92OWSceDlAw+daGkBfTHTzdLdkzscKv8+R8b
         mo3g==
X-Gm-Message-State: AOAM533gK+8SZXjUqWIdlZb9a3J4Tjvejr0OLZ22706WsU7jCcoLgD//
	4TfzIS9KvUZBi3X+uPe49wJBefkOFONzTXI0LpW0yw==
X-Google-Smtp-Source: ABdhPJyg/1HU0s2ONvtTgrt5iERBgGgkS6JytB18uzIi8C03bdvf44hVYzlIqOF4VsHI3+YtSAzrMa4Jr9LrNS0IJRg=
X-Received: by 2002:a17:906:33da:: with SMTP id w26mr51913539eja.472.1621035213402;
 Fri, 14 May 2021 16:33:33 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 May 2021 16:33:22 -0700
Message-ID: <CAPcyv4hDfxpYh1rvvqFCQ+eNk_XxZD3grUOYkHWbERfxky43xQ@mail.gmail.com>
Subject: [GIT PULL] dax fixes for v5.13-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, 
	nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/dax-fixes-5.13-rc2

...to receive a fix for a hang condition in the filesystem-dax core
when exercised by virtiofs. This bug has been there from the
beginning, but the condition has not triggered on other filesystems
since they hold a lock over invalidation events.

The changes have appeared in -next with no reported issues. The
patches were originally against v5.12 so you will see a minor conflict
with Willy's nr_exceptional changes. My proposed conflict resolution
appended below.

---

The following changes since commit 9f4ad9e425a1d3b6a34617b8ea226d56a119a717:

  Linux 5.12 (2021-04-25 13:49:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/dax-fixes-5.13-rc2

for you to fetch changes up to 237388320deffde7c2d65ed8fc9eef670dc979b3:

  dax: Wake up all waiters after invalidating dax entry (2021-05-07
15:55:44 -0700)

----------------------------------------------------------------
dax fixes for 5.13-rc2

- Fix a hang condition (missed wakeups with virtiofs when invalidating
  entries)

----------------------------------------------------------------
Vivek Goyal (3):
      dax: Add an enum for specifying dax wakup mode
      dax: Add a wakeup mode parameter to put_unlocked_entry()
      dax: Wake up all waiters after invalidating dax entry

 fs/dax.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --cc fs/dax.c
index 69216241392f,df5485b4bddf..62352cbcf0f4
--- a/fs/dax.c
+++ b/fs/dax.c
@@@ -524,8 -535,8 +535,8 @@@ retry

                dax_disassociate_entry(entry, mapping, false);
                xas_store(xas, NULL);   /* undo the PMD join */
-               dax_wake_entry(xas, entry, true);
+               dax_wake_entry(xas, entry, WAKE_ALL);
 -              mapping->nrexceptional--;
 +              mapping->nrpages -= PG_PMD_NR;
                entry = NULL;
                xas_set(xas, index);
        }
@@@ -661,10 -672,10 +672,10 @@@ static int __dax_invalidate_entry(struc
                goto out;
        dax_disassociate_entry(entry, mapping, trunc);
        xas_store(&xas, NULL);
 -      mapping->nrexceptional--;
 +      mapping->nrpages -= 1UL << dax_entry_order(entry);
        ret = 1;
  out:
-       put_unlocked_entry(&xas, entry);
+       put_unlocked_entry(&xas, entry, WAKE_ALL);
        xas_unlock_irq(&xas);
        return ret;
  }
