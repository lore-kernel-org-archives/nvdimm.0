Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF7B2561
	for <nvdimm@lists.linux.dev>; Fri, 21 Apr 2023 10:23:33 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-63b87d23729so1755714b3a.0
        for <nvdimm@lists.linux.dev>; Fri, 21 Apr 2023 03:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682072613; x=1684664613;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YZS/qa2Sx5clW8KmtmFWaBMmOya/Sr9fmjLNHSVPkhE=;
        b=WyI73hymxAAK2HgLtEGXSRvzeLBZPSkq3O+vJUvBZfbDg+xTqLEqcRhDt5b0wzEehX
         /ecBJp+kupYyvfIK+4cnp5dAS1y1ncPwvYtm/90vd1WAttddl51v1aIhDpWz/6kmU4V/
         IcHyAVwwiOa2Gt2uGS2hGFGalUY/EtcG4OgEfmrYvvVPq0EyV1a/YR3xsBPoHhfi2VUW
         a0oLPvMtOth2NXxi/1PRa5j/CRw5P4/9RRLQ02cpyt5WP9lPa+nRz91Zl0MBRaILouyH
         KhR0LjDCiMOeYMK0h5vORv6oJlfuK/dLwrLcyY2mcdmsoUQ7StgcEFUgxPL6b70CnTd8
         m4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682072613; x=1684664613;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZS/qa2Sx5clW8KmtmFWaBMmOya/Sr9fmjLNHSVPkhE=;
        b=UthzkMprJchwnz89Bzw/799ET38fBEt4e1B0qwf4CJp5hz2b35AGB3rNxHr+LBWQDx
         AxQTj8bBgsCGf+De9cMpiQ4X2hOySPxsK5Weglc0IpmTqFXIU+5uFPpsmp8xVP8x023l
         Zb5lgHUKFwRu8AkqHzHPcFxBeHYyzUI18wqQw7qxaX1qqxuMGoKKwYafXb+EIfpe1qlw
         /r0QJWa6Pq6US8VeMM57bdHVpI0hCCDDnk0UOk+Gfiik2Kt39KUTe7ApPIZDlKayq5Hs
         fWxT2vS2EC0Rsz3yPLeK3dBSXuh16wTOKFmXSoWUXyALNYE2RS1veTPhJ9Dy9tRBRc4D
         MWvA==
X-Gm-Message-State: AAQBX9fsM5JaY2prwJJwlcz9KKiyy5pwYknBlHPBvEKxQmhGv2p3FaA2
	dQUDnmcyfRaMut99ocwyemCrISwbA2E=
X-Google-Smtp-Source: AKy350aPKnpXL8D6j37Ig48zz80SZVTk1ot04ACy5bBbzl+33CWDWyLrk05fCOl9X7QPc5n8DCPJjw==
X-Received: by 2002:a05:6a00:994:b0:63d:3765:dc8e with SMTP id u20-20020a056a00099400b0063d3765dc8emr5597443pfg.32.1682072612783;
        Fri, 21 Apr 2023 03:23:32 -0700 (PDT)
Received: from joel-gram-ubuntu ([2407:4d00:2c02:823f:a8b1:ea50:522:2b01])
        by smtp.gmail.com with ESMTPSA id h69-20020a628348000000b0063db25e140bsm2703610pfe.32.2023.04.21.03.23.31
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 03:23:32 -0700 (PDT)
Date: Fri, 21 Apr 2023 18:23:31 +0800
From: "Joel C. Chang" <joelcchangg@gmail.com>
To: nvdimm@lists.linux.dev
Subject: a more descriptive msg/running without root privileges
Message-ID: <ZEJkI2i0GBmhtkI8@joel-gram-ubuntu>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When using daxctl, we don't get a hint/suggestion to use sudo/root.
For example, running "daxctl reconfigure-device -m system-ram dax0.0"
without sudo will only print the following:

libdaxctl: daxctl_dev_disable: dax0.0: failed to disable
dax0.0: disable failed: Device or resource busy
error reconfiguring devices: Device or resource busy
reconfigured 0 devices

But running it as sudo is okay. The message is a little misleading,
since the problem is not having root privileges, not the device being
busy.

IMO a hint in the end would be a nice reminder.
