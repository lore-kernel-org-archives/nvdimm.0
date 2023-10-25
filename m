Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A1C2D62F
	for <nvdimm@lists.linux.dev>; Wed, 25 Oct 2023 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-584081ad442so8389eaf.0
        for <nvdimm@lists.linux.dev>; Wed, 25 Oct 2023 10:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698256275; x=1698861075;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L0sZrs9MuS+86zDU/MsJ/ZulEyleyOije+QkqQwj6sY=;
        b=ghn6I1EUbzzEhbYupj8Dsh8BZA8+dCt3LXawGoKxz8MOo0U7+EN/0VFxBFulj7h3a+
         uUPx4H0FOpNYK99F9rokTB17BCJLFLNlNZ4NTO4P0pARXZOfdxPdbpt2vegEoO+neSaw
         J5WaN4ZB/fsewuYRVDkzlBBsGZ3J4IIJHkfl8NCjxFMYMwNgEbUWBs7CtvbAM9CndEsT
         II8V357alJQzzpfHd6C0ARPDpzCj9wuRtn7OYGlLFee39RmkAQ3uQ+XBQi6oz91/wiME
         pJpuFqIgS/fcEW0b4OANVfQgqxDELGe+be2wyCnkZLS82HFu4FP64Xzk+zKnA1BfXzrd
         oRow==
X-Gm-Message-State: AOJu0YyhHDTj/ZXRfNVjtvZ2LZjDsZYcoudTrJ06Nk8hVDYbLmvGB5t7
	/URuiftD2Rr3Mwaf5q7MUJ/JR8paL8nCc+Ahv00aUI7PwSE=
X-Google-Smtp-Source: AGHT+IFCA0SEdK9m8vSIvw85EgwaejMKhBk+2eajXLIBFquGyYGfOy8NuRsSUt4oLKxAESlfJ86CeK7wYlYQ0T/EOxM=
X-Received: by 2002:a4a:bd18:0:b0:581:e7b8:dd77 with SMTP id
 n24-20020a4abd18000000b00581e7b8dd77mr17606973oop.1.1698256275473; Wed, 25
 Oct 2023 10:51:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 25 Oct 2023 19:51:04 +0200
Message-ID: <CAJZ5v0hQGLq6JdJqVnhF_-DqXTjHubrt7khJi_ZoDU0diNTPMQ@mail.gmail.com>
Subject: [GIT PULL] ACPI fix for v6.6-rc8
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Linus,

Please pull from the tag

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 acpi-6.6-rc8

with top-most commit 9b311b7313d6c104dd4a2d43ab54536dce07f960

 ACPI: NFIT: Install Notify() handler before getting NFIT table

on top of commit f20f29cbcb438ca37962d22735f74a143cbeb28c

 Merge tag 'acpi-6.6-rc7' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm

to receive an ACPI fix for 6.6.

This unbreaks the ACPI NFIT driver after a recent change that
inadvertently altered its behavior (Xiang Chen).

Thanks!


---------------

Xiang Chen (1):
      ACPI: NFIT: Install Notify() handler before getting NFIT table

---------------

 drivers/acpi/nfit/core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)
