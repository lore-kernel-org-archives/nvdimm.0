Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F128320D
	for <nvdimm@lists.linux.dev>; Mon, 20 Feb 2023 21:25:11 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id e5so3936149plg.8
        for <nvdimm@lists.linux.dev>; Mon, 20 Feb 2023 13:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QESLl69yTFuw/UHokvPcBCupvaRLpWJFOxU9lYfGwWo=;
        b=N5kDy3DCypsUjNTIL6uKqPnIi4VuPmqW/5tC0XFeR4brBKCtKvN+UyuKUVGmY06M0r
         sqU4mlP5niEuq7PrXx4wZlFEqrMe/1cE7qvgAttb/jZOt6T6Egg+dd5TkiAeo1q3igMx
         woZqabfyycCzfKIe/OhmkQwObwKvDhvIXyYKUmG5xYEwZbx4LydK6tsL5DkHVdGaQPz+
         UGFB1y7LLPxMky0ZXcdRcqO+b/sepsCmbJ53Ch2qjYGFnID2tPRxSkN3Zh/KKk/yL8wh
         vSrFRSU0KA0AVOYVMpFoth6W5HDuoBsUQ3CGaOipNmKzGGSydVezHT3ZivmEpURxhaKy
         Tkyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QESLl69yTFuw/UHokvPcBCupvaRLpWJFOxU9lYfGwWo=;
        b=EQ1YL7rMCX+m111ZN4QAiCa6seFGv4KKT42MuytXWziOLzXRLTs/FSX9AmobXJ0jEH
         +fGCM7qAW2rctkVHnOuuYXE+z5Rs3lhmxHr+9pvz6zSWd0DPlZbvlBd0/OzfqJ8iBWX7
         ZoY6kszvVeP2RBc5ATDLskG+nYgNweF2DhPQ7U/O9MJBZ6peEMcECCYIbrxvc83x7qrU
         e3aZ6uIsG1kTs+TaxWI/yakFEiiDB7CKI9yBBt1CpDzrVGqdI3wQAa5h4/dsrzciybxP
         A5sT7/+DEngJ3ROts5BfK7ahRsJw2RyaJEryvD8sMEbuv3o+LXpakRX3KwN5r9gong8J
         Pifg==
X-Gm-Message-State: AO0yUKXP2X0jMBIU3c9Y5Ffm1DC6El1LCy1ttcNs/CTtSMIrdila2H6U
	hZ4XLEeWNTDumJxHafrfrlMFvA==
X-Google-Smtp-Source: AK7set/7p/rU3G5m3+Tu0pQdEIVeL6cGQ6eHnMmFlnj9qkTBEkSagKYJEBYzfb8nFNFw6MFe34UtYQ==
X-Received: by 2002:a17:903:234b:b0:196:595b:2580 with SMTP id c11-20020a170903234b00b00196595b2580mr2854902plh.0.1676928310567;
        Mon, 20 Feb 2023 13:25:10 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id h8-20020a170902748800b0019a7c890c61sm8337880pll.252.2023.02.20.13.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 13:25:09 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1pUDek-0007sH-Ij; Tue, 21 Feb 2023 08:25:06 +1100
Date: Tue, 21 Feb 2023 08:25:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	djwong@kernel.org, dan.j.williams@intel.com, hch@infradead.org,
	jane.chu@oracle.com, akpm@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH v10 2/3] fs: introduce super_drop_pagecache()
Message-ID: <20230220212506.GS360264@dread.disaster.area>
References: <1676645312-13-1-git-send-email-ruansy.fnst@fujitsu.com>
 <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676645312-13-3-git-send-email-ruansy.fnst@fujitsu.com>

On Fri, Feb 17, 2023 at 02:48:31PM +0000, Shiyang Ruan wrote:
> xfs_notify_failure.c requires a method to invalidate all dax mappings.
> drop_pagecache_sb() can do this but it is a static function and only
> build with CONFIG_SYSCTL.  Now, move its implementation into super.c and
> call it super_drop_pagecache().  Use its second argument as invalidator
> so that we can choose which invalidate method to use.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

I got no repsonse last time, so I'll just post a link to the
concerns I stated about this:

https://lore.kernel.org/linux-xfs/20230205215000.GT360264@dread.disaster.area/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
