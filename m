Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7838A1FBA
	for <nvdimm@lists.linux.dev>; Tue, 27 Jun 2023 06:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
 s=s29768273; t=1687846115; x=1688450915; i=markus.elfring@web.de;
 bh=kyZti+N13n/eg1XA3RWpnN8jDbqX61Mapv0U85O1QJo=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=N/5+8cC2YBxYK2xgU8R5oWdmatdgKIAftONomBwVQhC/xMPrEcs0ec2i+h1yeMRT1TlWe+o
 96rUKRGG9ahSN6mHq5R8CmY3irbeH+DqTjhqZL8CWdm8ZDoAUw+wRF6H0AXvMqZPtD1Cx16Uf
 HW1TD0JlLG1khv+kT+8D7G7Q2RMp9NtPkEw6HUZQesKn06EWxAW+jWW69V74X6yoSjSoFD12/
 i5OY8ANdImSqL44yS1V4OYTfLzDKGr4UeSN3rQvSI+wYzXqrCoNhWLsugZN1c6r1aZfYQJkt8
 TOkpvlMxxuibA4qhQN/Pm/KPmkhL8nw3H3tDe1BaoWIBXbeU4Y2A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MWi5s-1qXhO63pW4-00WzyW; Tue, 27
 Jun 2023 08:08:34 +0200
Message-ID: <be3db57c-29d0-cfc9-f0cc-1765b672c57e@web.de>
Date: Tue, 27 Jun 2023 08:08:19 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [v5 0/1] dax: enable dax fault handler to report
 VM_FAULT_HWPOISON
To: Jane Chu <jane.chu@oracle.com>, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Matthew Wilcox <willy@infradead.org>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <20230615181325.1327259-1-jane.chu@oracle.com>
 <b57afc45-6bf8-3849-856f-2873e60fcf97@web.de>
 <18ca0017-821b-595c-0d5a-25adb04196c1@oracle.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <18ca0017-821b-595c-0d5a-25adb04196c1@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:fdbUZZO32IgHwZluWxmMqT/FRq+d+sTbjHLEPUp4ZGqm1YqrYN5
 A0Ii8Bwgum0XUwXxZuNULreyYpmVUa/5Fv8tybRxjwmZf7YOYDFrH9j/6pIC1okOJO+WUED
 rNypPqMu6bjdnIVnEJywBU9YoEg8QXKuqF9n7AkJUtw1qCAwFTsFG0e2WBGYiKpI1ke3ZIX
 laVTYoY7b7p15Vt7ddKZg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6sekaRNOfuM=;ZjX02JN1LV3w65TrCfOlxL4pjll
 x38CGstj5lEw5extchG6BXfoSWcdgQxptjYhyAbz85y1uKFQ7QlOZRAAByn85UE4f5mpiZ3jT
 Nk/VtGD1Pa5tGvRaISChQGIzVMWYTc0Y/8DIYtfqBKiJFOwjiCw22Ap0gQ/7AyUSdcWfqsGO+
 45KwmFCFhcf5mChJB5R5eG8XEhlRXzOxI2We/JWrHDsU1RwX9zr+hKNVJ54iy3Ur5MNpBU+eM
 X8yc1+cF7ROPpu5aiziDgAFGxU4ZeSFG/prAB12sIe3tiaMBxG46+cEwwW4tIFGHerJIdrDW+
 +e8MIExl1SmcgRqiTfHf+Rq7OXWeHKgU1eMc2wMq/zYo8QmZNJYk4xx5W9sZphpxC4UgYu/cf
 ln+HRliG+M98eKtPAlmahy214oXyJnhiBozNUEfmZQot5SIHhbDmJobgxviTXoXjfMKnvE2ll
 2M+7/V809IBTZhP3spFSO9YpleddLvFbu7x1/VGn01DBN7Cp4oy39pT7fzge9d86S2gwiX9cn
 H93rnQrMiKcdjTXpFFxCHrqi0CdhSar5BnRG9DqzsmdToXwWtC5lL+0UH+U8zrj8X/2NeSs3U
 FifvAVqRBqh6kTC4dmsni4z8DQ6SoeOxRuP/QpD/QVsuYgEGAh4TRH+eB9e7QMiYHVR00Ei6z
 TeLFYcXKshEQAOlYvLyKiipIf+uM0+TpuvCxsFphldRlzU3QkxWmHBMtwMwNFVeZOo6fB3e2q
 /BBAfVpTTpJJwo/iU3mswSaeIOUnYrK6fS1wV8hP0zEloIICPh5PrON1kYfSMXY3XcOaVzfNw
 4sDCBu7QqWcXc9h4EU8OZm9zJriIbnG4K9vqzPn6brILeIIdlg+DFg6oATbFC+yyazO6HlRxp
 krGaGyOKfjsulHZ1AXAS9Wv0Fz/ETiTdUWYecAPapRjPhX4wPJNk4QbuqNgE+jwHDn9HvJEbw
 qyPxjQ==

> The thought was to put descriptions unsuitable for commit header in the cover letter.

How do you think about to put additional information below triple dashes
(or even into improved change descriptions)?

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.4#n686

Regards,
Markus
