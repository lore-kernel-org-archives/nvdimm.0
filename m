Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9EB1103
	for <nvdimm@lists.linux.dev>; Sat,  6 Aug 2022 16:51:30 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id v7so5974492ljj.4
        for <nvdimm@lists.linux.dev>; Sat, 06 Aug 2022 09:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=lnGqPaY2GUog4uwdnr/Yc5LiCp03/xOlV0gKZ4CC3VA=;
        b=V54OSIJK0wc+KwpvZzl2UQupuZVlchtMw6KlsvtAd7RDI4N11TDsA9e1mga53FpF/i
         uq3aENKL1b2bGmi5dhiM/v1nBvua1FU7IAcWjvkkoJqbxcC5jzHwau/JV0PZ1CpSSBeg
         QOiM82vr02XcO2OY6tpzrJSjgYUh9hr+rFkmM6w0ggYrqYvUE6TAouQiNeC0i8FEqepx
         X7z9tmjyk0bMY6RPM2BC/+0ded5Q9Ae+B843gIC3xQUB7gXj1tFazKmPT5SLg736TwPV
         Yi/dj9RUncQMVk5n8yNC0TmQPAlw5SrAl08F3mN/eZ3JhbLLn8ncZSlY1JTeFKYYMFpr
         tdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=lnGqPaY2GUog4uwdnr/Yc5LiCp03/xOlV0gKZ4CC3VA=;
        b=jyo8RQrFiw2pQTx6vciQU8bI1VbDB5EBr35ErgaG47nMAX1nex+0WforVlbHXAerl6
         YHFS5mi8GyBrDVMa/pab5ZRh1d7t6vQP1fzqaBiCujzbGlvVWbbuFe1d3UBcGc1GJc3q
         EntHJhwQHPXaQ9VrFXkQcl/ieCETnz5S+FzLxprEhOJlhnjUnP25QAccMHwLvYwCJZBT
         oChqEnj6R3x3AHGL9mEbyemEp69IpswCbxeqgheX8GsT8tUuvDdGBxXm+8Q8sHyJsdKh
         LzItOFTcW4qQ5oveotR0YOFHoOGpsbM3hhmcU45TsBc7jHd4DVGiQymSWPJFspvC197O
         q9Dw==
X-Gm-Message-State: ACgBeo1TEvycELE6Z0b7JVSOUNuCcDiwDEWrrMN+G/4ZzXaZPNMngsDU
	j8b9YbErcZD4HCoQTMP3b6QXAdQDAOG0qrqrILsJqA4dnOs=
X-Google-Smtp-Source: AA6agR7SeruvJEd9CulvDSGOtWs4ULEWcIuxYLwRFRXmo9zgRvyIb6jLfLHUte4sD9C0XDcKXsiS8y5mqGxN6p0OZo0=
X-Received: by 2002:a2e:9807:0:b0:25e:4860:fbf0 with SMTP id
 a7-20020a2e9807000000b0025e4860fbf0mr3366437ljj.333.1659804688017; Sat, 06
 Aug 2022 09:51:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Chloe Alverti <xloi.alverti@gmail.com>
Date: Sat, 6 Aug 2022 19:51:16 +0300
Message-ID: <CANpuKBMD4tWk-s3DRSvzquTVfoDMp+5X_fp90N1HDHkb4u-v7Q@mail.gmail.com>
Subject: The future of DAX in linux kernel
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi!

My name is Alverti Chloe and I am a PhD student! I have been
working/studying the past year on system support for persistent
memory.
I wanted to kindly ask you your view about DAX kernel support; will it
continue to evolve/be supported in the mainline since Optane memory
has announced to be over?
Is DAX going to be used as an interface for CXL compatible storage devices?

Thank you very much in advance!
Best Regards,
Chloe
