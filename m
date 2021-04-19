Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782E62F9A
	for <nvdimm@lists.linux.dev>; Mon, 19 Apr 2021 14:52:32 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id a18so2487041qtj.10
        for <nvdimm@lists.linux.dev>; Mon, 19 Apr 2021 07:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=KhvcKc7QjNaMzzoP2DqaAQ2DswGh4Up75U0SY/CDE1M=;
        b=SWzSxgL1qc13byCL4YERb3vGC+KqYgE6dg+5x1p9J6Qi61Pa7c46fcr1tHmvjdCFzg
         N/iS9Vxpzat+nU4c+gW+NBkVjbnZVJvWovsWSOfd+63cOK6CaCdTFuCph1K7WOQybL6S
         u3NWRb1FCRWZXIxYdFt3AHA9TARfvfWj8daOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=KhvcKc7QjNaMzzoP2DqaAQ2DswGh4Up75U0SY/CDE1M=;
        b=Hb8kmgC4jGJaTj983gqJ3/o9c+dCTmdkdrEMDfq+HN41JWkWZhmUGz/OdH8WKKsHRl
         J24W5xC+npsEalkWDn7V/6RMwD4H3KSjKYNAUXUeAhsm4nxGOCh6MMp5nVvL5mhnbnZe
         PrgmTpTidweTkOT9ZNtPP2e4nbKEP7/jWhrJSWhdn5oBcyhS4s2EAbsBTADWtpCw6khp
         gYhSHYm87A4VBgRSIYVn9Vt21uAEYsn5sBmCjY0oV0/cGI3EHDx/erla1Pm4VeH6urI9
         e+imwrfyBsRkT1afJQGBTOOIZfrHOJjz1cwruLfE1ba68YABDKGpLkmlHf5UlJcU+9ut
         pZww==
X-Gm-Message-State: AOAM531MZeKAL6j5PNng95X8rEHO5gQ3m8I8h3Or22PBruKO/FNbDUnN
	48+zgYznN0LUo5gw9KmET0p49Nw8qN02zxJN178=
X-Google-Smtp-Source: ABdhPJxorU8pc8nfeWWfQKS42g9iTv8IM7iHS7BwZQ1aUeU7ImZa8BotmsNkaZRZpylT8S3f0m+xlA==
X-Received: by 2002:a05:622a:1793:: with SMTP id s19mr12369460qtk.132.1618843951226;
        Mon, 19 Apr 2021 07:52:31 -0700 (PDT)
Received: from nitro.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id k126sm9762333qkb.4.2021.04.19.07.52.30
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 07:52:30 -0700 (PDT)
Date: Mon, 19 Apr 2021 10:52:29 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: nvdimm@lists.linux.dev
Subject: Test delivery to new list address
Message-ID: <20210419145229.ohoqnpu36sex6gjx@nitro.local>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Testing delivery to new archive, please ignore.

-K
