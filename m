Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF2113F00E
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710157; cv=none; b=i1yqhc3ccgzbI+Ra2Fpi604/dhrNREgw5u2oFgpTsdECcBTJ+17/yhgxj8y7RS1yHO5Cbn4iXYd14GAJg1LUcFKxDe4y4spkVP+XJtlqXkcOjPlX07c69DB0D39sXgLjE99myLU+RWe1T/urSI+zarhQf3M7dEP60gvnYevdRc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710157; c=relaxed/simple;
	bh=B2obSwDEVHBkcnZehtnKyWZ0YBP4Jo3Z+lXXRsHPDaw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XhKrjNlRyR5p2qP1ODkRqmFs6pUuxvMRLxXEezI/E9xxrWFvH7WZ0c+z/6RBRDEw4E4FQJPt81ANGXHoLzucWWEzqo/HoWonFfN4+b78nNR49mPSs8U6ERL4YqB9FU15XePdVZSqvFrRWfwcYFfHiW3eAD3obzGullSYSoEX2B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WaUQhNd7; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WaUQhNd7"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3c15bef14c3so607571b6e.2
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710154; x=1709314954; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFTut3+4qkGhS8AYHqbTNfHoA7qF2QMx6EtGEpLVCik=;
        b=WaUQhNd7ez59BmrB4e6+wktf5cMTvbty61OG3PZc4cbMPBdDyu2zVxETq2zsQmC5uj
         aUrwJ7yAAwCjEfFNoOi/qMbgYTswj5h/D1VPGpjZx7d7onb+boDBvLdV79q+VI4Y2Ml2
         mF3kww6l9CmWdha6HiKPfWvsHjgRnG17twORqPqhZheRBjvCM11yUgfS4pvCvQnAuF2b
         0OM6VPrMQyVshv93L1gbHbAmL0z74owNgfTgJkCWM8vY22maEL8FbKLKPE1/91Yn0Fxt
         pCR3QmFUzP0lm5ui3NklPu0DzWSquUKJR+54Iykfu7dXmEjHhMQSKJ8+coUNlj8cyWON
         bt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710155; x=1709314955;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aFTut3+4qkGhS8AYHqbTNfHoA7qF2QMx6EtGEpLVCik=;
        b=HO0WbSOFqWgCY9ELtvwGGsKvPOEOi+lnBmYl3D88ezJTF1lRDMvDJdSLq0a3zAGbot
         Ow7WeovJVfs2VxNeLMUVKsGG1WY35hYMu8M9rfYB5KZq9QJHpvD0U4Sfg6BUdQzVzone
         vKXDooU7CSMbkatulp2tLwQLCrnNhjfUMqjDlSIL84MSLyFL1M8pLKoXpb2GZ9v1np42
         E3SOhNu7fiNtrFHODF0XpnFGNT0pjAux9fKuGnYK5Ecpv/3fNTHU1EaOBGSvfa5u3l4o
         Be3iIYrdDYoBZV7yNMQfFhKOvekh0TlvLvatUa9B8OE1dpBBQGSFa4h4z3ZfkhyuTYzn
         aYcg==
X-Forwarded-Encrypted: i=1; AJvYcCWgQ858Um/F0+KS8T72pRlRX/6Q8Bd7VagtxGjGs19f6ngUz5ZL42w+ln/DawKI1TJFbFhN85SVbIJWomx54VRwyrziR8BZ
X-Gm-Message-State: AOJu0YzRXQTdlTTssyn3tfHwB7MayC8u+i681Zlgk0xoneEOr83mQhld
	UDt+aaq4USJXn7GU6ftAjA/AFhVRaK3fXv/XlqyVmy7119ZOiy1P
X-Google-Smtp-Source: AGHT+IHKTLvZO2eArKSdPtAv4KEnKXuwuYYaVhAXebKDRq6B4BATf8gx4jBDt1zV4RE8roWGKtQyow==
X-Received: by 2002:a05:6870:f6a1:b0:21e:9b99:53d8 with SMTP id el33-20020a056870f6a100b0021e9b9953d8mr561935oab.22.1708710154758;
        Fri, 23 Feb 2024 09:42:34 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:34 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John@Groves.net,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	John Groves <john@groves.net>
Subject: [RFC PATCH 06/20] dev_dax_iomap: Add CONFIG_DEV_DAX_IOMAP kernel build parameter
Date: Fri, 23 Feb 2024 11:41:50 -0600
Message-Id: <13365680ad42ba718c36b90165c56c3db43e8fdf.1708709155.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <cover.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the CONFIG_DEV_DAX_IOMAP kernel config parameter to control building
of the iomap functionality to support fsdax on devdax.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index a88744244149..b1ebcc77120b 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -78,4 +78,10 @@ config DEV_DAX_KMEM
 
 	  Say N if unsure.
 
+config DEV_DAX_IOMAP
+       depends on DEV_DAX && DAX
+       def_bool y
+       help
+         Support iomap mapping of devdax devices (for FS-DAX file
+         systems that reside on character /dev/dax devices)
 endif
-- 
2.43.0

