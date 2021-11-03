Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9805A68
	for <nvdimm@lists.linux.dev>; Wed,  3 Nov 2021 19:29:27 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso2303251otg.9
        for <nvdimm@lists.linux.dev>; Wed, 03 Nov 2021 12:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Y3d6E1SHGhXJn4Dvk0e2wYnCWALGfieMsoRHb/exO38=;
        b=Nlpj9VQg9J9S4S48NzQMds56GucWKbqxz1cKoQevhTMAyjBD6P8S6lpVHh7hCKXk8Z
         ubvCBQZIhFNRl75oWDVIjQU86EMiV5BhFO4w0FanEa2QNigig0oKKWExBqrHjOxyfbZD
         x4AaeV2afFFIW2IAMXWX4paB5XyrVb/Uj4cGO1tMbtbwEDT6wDMYYwljYiyX6/tslQUV
         8LEDllACSnwAVIXM1ijiEaFVt5mYJnLQ1pujeRWntcFSPR4ETsIliUxJFSTLCUzkcly1
         wzz2jUT2upPO6voi4OfJ1Xs0INnNeCOy3lE3XgpYnKijSpinp+ba1DsNqikIJMr0lLkr
         b6DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Y3d6E1SHGhXJn4Dvk0e2wYnCWALGfieMsoRHb/exO38=;
        b=pWvnmrjNoiBQVfCMxDi50yA7tUf4nxh/jabTeBMxVtUtukMy39W5A1jhHmBrFwDn7r
         u1dKv3enXIw/hlmsoVh2d5RORwTDL28glUOWJ83JoO8b/jImH1aBEsY+HSpIaQCnv+G8
         wgCjsh1KdVXdT72OKiAFfeCvoBdtPOp4PJR0eFT/EVjCsmGiBV+qSGyq+aSIZdO/4LlI
         iHvuMBDC6lOC/v1NJHdJjgmb0r95l46hqA1QxlwXs4y5Z0BvI50VSqzM0Ls5NsBLNVYm
         Zz/PZYFxoeAHT0KDKtrSjnhaCzgXhvx0ET4q3Yjiiy/qkaxh+uaykPNmCvTBMP4On574
         7R9A==
X-Gm-Message-State: AOAM533GO0J1GDWK9u7HJ3CAlNqHnnx5n4k370dhy5CihkuN3fgYgupY
	PqbKb6bVtZWnkhEToEuenjiUzg==
X-Google-Smtp-Source: ABdhPJyQzzTX1UgPm7SvPYQQRUJBgfitrA3qciUqirF/PD9KbBoSKsEuMnzT7nuMc4W5j3DiZHufsg==
X-Received: by 2002:a9d:70c4:: with SMTP id w4mr21718621otj.78.1635967766484;
        Wed, 03 Nov 2021 12:29:26 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z13sm748257otq.53.2021.11.03.12.29.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 12:29:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: vishal.l.verma@intel.com, ira.weiny@intel.com, dave.jiang@intel.com, Luis Chamberlain <mcgrof@kernel.org>, hch@lst.de, dan.j.williams@intel.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20211103165843.1402142-1-mcgrof@kernel.org>
References: <20211103165843.1402142-1-mcgrof@kernel.org>
Subject: Re: [PATCH v3] nvdimm/btt: do not call del_gendisk() if not needed
Message-Id: <163596776548.186543.8354031131670153996.b4-ty@kernel.dk>
Date: Wed, 03 Nov 2021 13:29:25 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 3 Nov 2021 09:58:43 -0700, Luis Chamberlain wrote:
> del_gendisk() should not called if the disk has not been added. Fix this.
> 
> 

Applied, thanks!

[1/1] nvdimm/btt: do not call del_gendisk() if not needed
      commit: 3aefb5ee843fbe4789d03bb181e190d462df95e4

Best regards,
-- 
Jens Axboe


