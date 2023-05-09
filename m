Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A898E17FE6
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 15:30:45 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1aae5c2423dso58884985ad.3
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 08:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683646245; x=1686238245;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7Kfo5IoYaNITwCS7KZb9AEWHVN5q9jOIDAvAT9AqOw=;
        b=GXPSX8ExSi7KHfhO/6v4hOCe16Q9vNVbKrR4QOAQ3O3SzLB+Pnaw+gZ+/jIZTvz5m3
         CAa98t4PLZwr7Ijt+tp8S8dlexzqNVtym+vLckKPTJc++p4aL24RReKl6zmZIH8NPDhb
         Qp1QwxAPS3ANNf+UnnsHkswnyfl2l+ZDgEfoM2RFbxSEpaHoymh5sdM5KaqEdG01C6qL
         Vn3p8LHX6kf7NfjoMg6I6qQ4oC5dW8jKBh2szTjFk42fjMJLpy1P0YFlyJIw26MEQXL3
         tFJUe4nwFa54fyasVvICKofuc3f2WwfsUpTtL6rYC/Y73rX/SXEAQWg2wJB8VZeSwbbh
         InDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683646245; x=1686238245;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l7Kfo5IoYaNITwCS7KZb9AEWHVN5q9jOIDAvAT9AqOw=;
        b=eKa3f44ObDZ75yPBM3702E6VSEnPWpYXG+FDYlkDVedKE83umpn3wIKivYdGOhyS0J
         GCeM3ZeTEgjbU7y5MYKG/LYeELloGDwyTgV8H9h55uPcUsWLmqBhKKTukUiovPwo4xxw
         U9EkElPFE9p5FIH4rkPqxFRy2qif6kyw8pxXLdlU1NqgHpobkK4T5/1NzctFGKvxiMxa
         HQmEVmSO3ekSmu0vsXPdwBgKUKTDUocdzv5iVxsZ1SPzvZCsuU3qkgQIQ8coXRVoSkcN
         Wnmu193yd0qj0gMAr0wfSCAPJONCzje20G16S9WRBkOHAo1J+2DPkX2JAwqledFj6hLe
         G4FQ==
X-Gm-Message-State: AC+VfDxv0DezKTosP071bEvE2MVZ4422k7fMwgGhzJy83Kwh4xXKlrO1
	I3A48n+C07BYWEXziR5PgUoeNXST5KY=
X-Google-Smtp-Source: ACHHUZ4yAbFTXp+9NWzeX7WmWaR2uMzGlq8yNtb1Pf9WAxKkJ8rzbuXvV6ELPHtK3pLRsbFoK8+Gjg==
X-Received: by 2002:a17:902:cec2:b0:1a8:1f41:59ba with SMTP id d2-20020a170902cec200b001a81f4159bamr17262823plg.38.1683646244697;
        Tue, 09 May 2023 08:30:44 -0700 (PDT)
Received: from minwoo-desktop ([1.230.133.98])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902e9cd00b001ab0669d84csm1750195plk.26.2023.05.09.08.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:30:44 -0700 (PDT)
Date: Wed, 10 May 2023 00:30:40 +0900
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: ndctl-v77: LIBCXL_5 not found
Message-ID: <ZFpnIICkh3Wpqmn/@minwoo-desktop>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello ndctl,

With the recent tag (v77), after building it with the following
commands, `cxl` command is not albe to find `LIBCXL_5` version from the
/lib/libcxl.so.1 installed.

	meson build
	ninja -C build
	meson install -C build

	root@vm:~/work/ndctl.git# cxl
	cxl: /lib/libcxl.so.1: version `LIBCXL_5' not found (required by cxl)
	root@vm:~/work/ndctl.git# ls -l /lib/libcxl.so.1
	lrwxrwxrwx 1 root root 15 May  9 15:28 /lib/libcxl.so.1 -> libcxl.so.1.1.3

I'm not pretty certain how to go through with this, but I'm using v77
with the following patch which might not be a good one to solve it.


---
diff --git a/meson.build b/meson.build
index 50e83cf770a2..665b8e958178 100644
--- a/meson.build
+++ b/meson.build
@@ -307,7 +307,7 @@ LIBDAXCTL_AGE=5

 LIBCXL_CURRENT=5
 LIBCXL_REVISION=0
-LIBCXL_AGE=4
+LIBCXL_AGE=5

 root_inc = include_directories(['.', 'ndctl', ])



It would be great if any folks here can provide advices on this.

Thanks,
